import QtQuick 2.15
import QtQuick.Window 2.14
import QtQuick3D 1.15
import QtQuick.Controls 2.12
import QtQuick3D.Helpers 1.15
import Object3dModel 1.0

Window {
    id: window
    property int currentIndex: 0
    width: 1280
    height: 720
    visible: true

    ListModel {
        id: instances
        ListElement {
            index: -1
            instance: null
        }
        Component.onCompleted: instances.clear();
    }

    Object3dModel {id: model }

    Row {
        anchors.fill: parent
        spacing: 10
        Column {
            spacing: 10
            ListView {
                id: simpleView
                width: 200; height: 300
                model: model
                delegate:
                    Text {
                        id: simpleDelegate
                        font.pointSize: 12
                        text: model.name
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                simpleView.currentIndex = index
                                detailesLabel.text =
                                        "Selected item: "+ model.name + "\n"
                                              + " size: "+ model.size  + "\n"
                                                 + " x: "+ model.x  + "\n"
                                                 + " y: "+ model.y  + "\n"
                                                 + " z: "+ model.z
                            }
                        }
                    }
                highlight: Rectangle { color: "lightsteelblue"; radius: 5}
                focus: true
                onCurrentIndexChanged: if (simpleView.currentIndex == -1) detailesLabel.text = "Selected item: -"
            }
            Rectangle {
                id: selectedDetailes
                width: 200
                height: 150
                color: "lightgray"
                Text {
                    id: detailesLabel
                    anchors.centerIn: parent
                }
            }
            Button
            {
                text: "Добавить"
                onClicked: dialog.open()
            }
            Button
            {
                text: "Удалить"
                enabled: simpleView.currentIndex != -1
                onClicked:
                {
                    instances.get(simpleView.currentIndex).instance.destroy();
                    instances.remove(simpleView.currentIndex);
                    model.removeRow(simpleView.currentIndex);
                }
            }
            Row {
                spacing: 20
                Button
                {
                    text: "Zoom-"
                    enabled: camera.fieldOfView < 90 ? true : false
                    onClicked: camera.fieldOfView += 10
                }
                Button
                {
                    text: "Zoom+"
                    enabled: camera.fieldOfView >= 30 ? true : false
                    onClicked: camera.fieldOfView -= 10
                }
            }
        }
        Rectangle {
            width: parent.width - 200
            height: parent.height
                View3D {

                    id: view
                    anchors.fill: parent

                    environment: SceneEnvironment {
                        clearColor: "skyblue"
                        backgroundMode: SceneEnvironment.Color
                    }

                    DirectionalLight {
                        eulerRotation.x: -30
                        eulerRotation.y: -70
                    }

                    Node {
                        position: Qt.vector3d(0, 0, 0);

                        PerspectiveCamera {
                            id: camera
                            position: Qt.vector3d(0, 300, 600)
                        }

                        eulerRotation.y: -90
                    }

                    Node {
                        id: spawner

                        function addShape(type, size, x, y, z)
                        {
                            var shapeComponent = Qt.createComponent(type+".qml");
                            let instance = shapeComponent.createObject(spawner,
                                { "position": Qt.vector3d(x, y, z), "scale": Qt.vector3d(size/5,size/5,size/5)});

                            return instance;
                        }
                    }
                    WasdController {
                        controlledObject: camera
                        Component.onCompleted: console.log("#### ", mouseEnabled);
                    }
//                    OrbitCameraController {
//                        anchors.fill: parent
//                        origin: spawner
//                        camera: camera
//                    }
                }
            }

    }
    Dialog {
        id: dialog
        anchors.centerIn: parent
        modal: true
        title: "Добавить объекты"
        spacing: 20
        standardButtons: Dialog.Ok | Dialog.Cancel

        contentItem:
                Column {
                spacing: 30
                Row {
                    spacing: 10
                        Text {text: qsTr("Тип:")
                        ComboBox {
                            id: typeSelector
                            model: ["Sphere", "Cube", "Cylinder", "Cone"]
                        }
                    }
                }
                Row {
                    spacing: 10
                        Text {text: qsTr("Размер:")
                        Slider {
                            id: sizeSelector
                            orientation: Qt.Horizontal; from: 1; to: 10
                        }
                    }
                }
                Row {
                    spacing: 10
                        Text {text: qsTr("Количество:")
                        Slider {
                            id: countSelector
                            orientation: Qt.Horizontal; from: 1; to: 20
                        }
                    }
                }
            }

        onAccepted:
        {
            for (var i = 0; i < countSelector.value; i++)
            {   currentIndex++;
                if (currentIndex > 10000)
                {
                    console.log("Object list: Out of index, can't create more objects");
                    return;
                }
                add3DObject(typeSelector.currentText, sizeSelector.value);
            }
        }
    }

    function add3DObject(type, size)
    {
        let x = Math.floor(Math.random() * 300)
        let y = Math.floor(Math.random() * 300)
        let z = Math.floor(Math.random() * 300)
        model.append(type+" "+currentIndex, size, x, y, z);
        instances.append({"index" : currentIndex, "instance" : spawner.addShape(type, size, x, y, z)});
    }
}
