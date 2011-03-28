/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Labs.Components 0.1
import MeeGo.App.Email 0.1

Column {
    id: header

    property alias subject: subjectEntry.text
    property string fromEmail: ""

    property alias toModel: toRecipients.model
    property alias ccModel: ccRecipients.model
    property alias bccModel: bccRecipients.model
    property alias attachmentsModel: attachmentBar.model
    property EmailAccountListModel accountsModel
    property int priority: 0

    property bool showOthers: false

    focus: true

    spacing: 5

    function completeEmailAddresses () {
        toRecipients.complete ();
        ccRecipients.complete ();
        bccRecipients.complete ();
    }

    // EmailAccountListModel doesn't seem to be a real ListModel
    // We need to convert it to one to set it in the DropDown
    onAccountsModelChanged: {
        for (var i = 0; i < accountsModel.getRowCount (); i++) {
            var emailAddress, displayName;

            emailAddress = accountsModel.getEmailAddressByIndex (i);
            displayName = accountsModel.getDisplayNameByIndex (i);
            realAccountsModel.append ({"emailAddress": emailAddress, "displayName": displayName});

            if (i == scene.currentMailAccountIndex)
                fromEmail = emailAddress;
        }
        accountSelector.dataModel = realAccountsModel;
    }

    ListModel {
        id: realAccountsModel
    }

    Row {
        width: parent.width
        spacing: 5
        height: 53
        z: 1000

        VerticalAligner {
            id: fromLabel
            text: qsTr ("From:")
        }

        EmailEntry {
            id: accountSelector
            width: parent.width - (ccToggle.width + fromLabel.width + 30)
            selectedIndex: scene.currentMailAccountIndex;

            onEmailChanged: {
                fromEmail = emailAddress;
            }
        }

        Image {
            id: ccToggle
            width: 100
            height: parent.height

            source: "image://theme/btn_blue_up"

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Cc/Bcc")
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    header.showOthers = !header.showOthers;
                }
            }
        }
    }

    Row {
        width: parent.width
        spacing: 5

        // Expand to fill the height correctly
        height: toRecipients.height

        VerticalAligner {
            id: toLabel
            text: qsTr ("To:")

            function addContactTo (contact) {
                console.log ("email address:" + contact.emailAddress);
                toModel.append ({"name":"", "email":contact.emailAddress});
            }

            onClicked: {
                var picker = contactsPicker.createObject (scene);
                picker.promptString = qsTr ("Select contact");
                picker.contactSelected.connect (addContactTo);
                picker.show ();
            }
        }

        EmailRecipientEntry {
            id: toRecipients

            width: parent.width - (toLabel.width + 25/* + addTo.width + 30*/)
        }
    }

    Row {
        width: parent.width
        spacing: 5

        height: ccRecipients.height
        visible: showOthers

        VerticalAligner {
            id: ccLabel
            text: qsTr ("Cc:")

            function addContactTo (contact) {
                console.log ("email address:" + contact.emailAddress);
                ccModel.append ({"name":"", "email":contact.emailAddress});
            }

            onClicked: {
                var picker = contactsPicker.createObject (scene);
                picker.promptString = qsTr ("Select contact");
                picker.contactSelected.connect (addContactTo);
                picker.visible = true;
            }
        }

        EmailRecipientEntry {
            id: ccRecipients

            width: parent.width - (ccLabel.width +25)
        }

    }

    Row {
        width: parent.width
        spacing: 5

        height: bccRecipients.height
        visible: showOthers

        VerticalAligner {
            id: bccLabel
            text: qsTr ("Bcc:")

            function addContactTo (contact) {
                console.log ("email address:" + contact.details.emailAddress);
                bccModel.append ({"name":"", "email":contact.emailAddress});
            }

            onClicked: {
                var picker = contactsPicker.createObject (scene);
                picker.promptString = qsTr ("Select contact");
                picker.contactSelected.connect (addContactTo);
                picker.show ();
            }
        }

        EmailRecipientEntry {
            id: bccRecipients

            width: parent.width - (bccLabel.width + 25)
        }
    }

    Row {
        width: parent.width
        height: 53
        spacing: 5

        TextEntry {
            id: subjectEntry

            width: parent.width - 20
            height: parent.height

            defaultText: qsTr ("Enter subject here")
        }
    }

    AttachmentView {
        id: attachmentBar
        width: parent.width - 20
        height: 41
        opacity: (model.count > 0) ? 1 : 0
    }

    Component {
        id: contactsPicker

        ContactsPicker {
        }
    }
}
