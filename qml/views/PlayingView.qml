import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import "../components"
import "../delegates"

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5

    RotationAnimator {
        loops: Animation.Infinite
        target: rotatingIcon;
        from: 0;
        to: 360;
        duration: 3000
        running: mainQmlApp.isMusicPlaying
    }

    ColumnLayout
    {
        anchors.fill: parent

        TopNavBar
        {
            onBackClicked: mainQmlApp.stackLayout.currentIndex=1
            onMusicPlaylistClicked: mainQmlApp.stackLayout.currentIndex=0
            onMenuClicked: {}
        }

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: musicIcon.height+4

            Rectangle
            {
                id: musicIcon
                width: root.width*0.6; height: width; radius: width/2; color: "#3f5471";
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                AppIcon
                {
                    id: rotatingIcon;
                    anchors.centerIn: parent
                    icon: "\uf51f"; color: "#516b8e"
                    size: 0.75*parent.width
                }

                RoundProgressBar
                {
                    width: 1.4*parent.width
                    anchors.centerIn: parent
                    progressColor: "white"
                    foregroundColor: "#47689e"
                    dialWidth: 5
                    showText: false
                    startAngle: -300
                    spanAngle: -120
                    value: playerDuration === 0? 0:(playerPosition * 100)/playerDuration
                }
            }
        }

        Item
        {
            Layout.preferredHeight: 40
            Layout.preferredWidth: 0.9*root.width
            Layout.alignment: Qt.AlignHCenter
            clip: true

            Text{
                id: txt
                verticalAlignment: Text.AlignVCenter
                color: "white"; font.pixelSize: 18
                text: musicTitle_.length>35? musicTitle_.slice(0,35)+"...":musicTitle_

                Component.onCompleted: {
                    if(txt.width > parent.width)
                        anchors.left = parent.left

                    else
                        anchors.horizontalCenter= parent.horizontalCenter
                }
            }
        }

        Text
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: mainQmlApp.foreColor; font.pixelSize: 14
            text: artistName
        }

        Item
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            Item{
                height: 40; width: 40
                anchors.right: playpausebtn.left
                anchors.rightMargin: 40
                anchors.verticalCenter: parent.verticalCenter

                AppIcon
                {
                    anchors.centerIn: parent
                    icon: "\uf04a"
                    color: "#5d7ec3"
                    size: 25
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: { QmlInterface.playPrevious() }
                }
            }

            Item{
                id: playpausebtn
                height: 40; width: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                AppIcon
                {
                    anchors.centerIn: parent
                    icon: mainQmlApp.isMusicPlaying? "\uf04c":"\uf04b"
                    color: "#5d7ec3"
                    size: 25
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: {
                        if(!mainQmlApp.isMusicPlaying)
                        {
                            if(musicModel.count>0)
                                mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                        }
                        else
                            mainQmlApp.isMusicPlaying = !mainQmlApp.isMusicPlaying
                    }
                }
            }

            Item{
                height: 40; width: 40
                anchors.left: playpausebtn.right
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter

                AppIcon
                {
                    anchors.centerIn: parent
                    icon: "\uf04e"
                    color: "#5d7ec3"
                    size: 25
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked: { QmlInterface.playNext() }
                }
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.preferredHeight: 70

            RowLayout
            {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                Item{
                    // Shuffle
                    height: 40; width: 40
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                    AppIcon
                    {
                        anchors.centerIn: parent
                        icon: "\uf074"
                        color: mainQmlApp.isShuffleEnabled? "white":foreColor
                        size: 25
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            mainQmlApp.isShuffleEnabled = !mainQmlApp.isShuffleEnabled
                        }
                    }
                }

                Item{
                    // Add to playlist
                    height: 40; width: 40
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                    AppIcon
                    {
                        anchors.centerIn: parent
                        icon: "\uf067"
                        color: foreColor
                        size: 25
                        visible: false
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {}
                    }
                }

                Item{
                    // delete
                    height: 40; width: 40
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                    AppIcon
                    {
                        anchors.centerIn: parent
                        icon: "\uf1f8"
                        color: foreColor
                        size: 25
                        //visible: false
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: { QmlInterface.removeFromPlaylist(currentMusicIndex) }
                    }
                }


                Item{
                    // Repeat
                    height: 40; width: 40
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignHCenter

                    AppIcon
                    {
                        anchors.centerIn: parent
                        icon: mainQmlApp.repeatIndex === 1? "\uf366":"\uf364"
                        color: mainQmlApp.repeatIndex === 0? foreColor:"white"
                        size: 25
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            mainQmlApp.repeatIndex += 1
                            if(mainQmlApp.repeatIndex === 3)
                                mainQmlApp.repeatIndex = 0
                        }
                    }
                }
            }
        }
    }
}
