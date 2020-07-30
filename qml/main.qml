import QtQuick 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import "./views"
import "./components"

ApplicationWindow{
    id: mainQmlApp
    visible: true
    width: 350
    height: 600

    property string darkThemeColor: "#00142f"
    property string foreColor: "#415673"
    property alias fontAwesomeFontLoader: fontAwesomeFontLoader
    property alias stackLayout: stackLayout
    property alias menuDelegatePopup: menuDelegatePopup
    property alias menuPopup: menuPopup

    property bool isMusicPlaying: false
    property bool isMusicPaused: false
    property bool isShuffleEnabled: false
    property int repeatIndex: 0
    property int currentMusicIndex: 0
    property int clickedIndex: -1

    property int playerPosition: 0
    property int playerDuration: 0

    property real yCoordinate: 0

    property string musicTitle_ : ""
    property string artistName: "Unknown Artist"

    property ListModel musicModel: ListModel {}

    function updateTitles()
    {
        if(musicModel.count>0)
        {
            try{

                musicTitle_ = musicModel.get(currentMusicIndex)._title

            } catch (err)
            {

            }
        }
    }

    function getArtist()
    {
        if(musicModel.count>0)
        {
            musicTitle_ = musicModel.get(currentMusicIndex)._title

            var artist = musicTitle_.split("-")[0]

            artistName = artist===""? "Unknown Artist":artist.length>40? artist.slice(0,39)+" ...":artist

        }
    }

    onMusicTitle_Changed: getArtist()

    onIsMusicPlayingChanged: {
        if(mainQmlApp.isMusicPlaying)
            QmlInterface.startPlaying()

        else
            QmlInterface.pausePlaying()
    }

    onIsMusicPausedChanged: {
        if(mainQmlApp.isMusicPaused)
            QmlInterface.pausePlaying()

        else
            QmlInterface.startPlaying()
    }

    onIsShuffleEnabledChanged: {
        QmlInterface.setShuffle(isShuffleEnabled);
    }

    onRepeatIndexChanged: {
        QmlInterface.setPlaybackMode(repeatIndex);
    }

    onCurrentMusicIndexChanged: {
        QmlInterface.setCurrentIndex(currentMusicIndex)

        updateTitles()
    }

    Connections
    {
        target: QmlInterface

        onMusicIndexChanged: {
            // Changed from Qt player

            if(mainQmlApp.currentMusicIndex !== QmlInterface.getCurrentMusicIndex())
                mainQmlApp.currentMusicIndex = QmlInterface.getCurrentMusicIndex()
        }

        onMusicListSizeChanged: {
            // Update music list

            musicModel.clear()

            for(var i=0; i<data.length; i++)
                musicModel.append({"_no":i+1, "_title":data[i], "_length":"03.20"})

            updateTitles()

            // console.log("Music list size changed .. qml")
        }

        onPlayerPositionChanged: {
            // console.log("Position: ", data)

            playerPosition = data;
        }

        onMusicDurationChanged: {
            // console.log("Length: ", data)

            playerDuration = data;
        }
    }


    Rectangle
    {
        color: darkThemeColor
        anchors.fill: parent

        StackLayout
        {
            id: stackLayout
            currentIndex: 1
            anchors.fill: parent

            PlaylistView
            {
                id: playlistView
            }

            PlayingView
            {
                id: playingView
            }
        }
    }

    FontLoader
    {
        id: fontAwesomeFontLoader
        source: "qrc:/assets/fonts/fontawesome.otf"
    }

    MenuPopup
    {
        id: menuPopup
        x: mainQmlApp.width - 50 - width
        y: 5
    }

    MusicDelegateMenuPopup
    {
        id: menuDelegatePopup

        x: mainQmlApp.width - 50 - width
        y: yCoordinate

        onClosed: clickedIndex = -1
    }

}
