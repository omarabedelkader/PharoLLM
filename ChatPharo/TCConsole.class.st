Class {
	#name : #TCConsole,
	#superclass : #ComposablePresenter,
	#instVars : [
		'chat',
		'list',
		'input'
	],
	#category : #ChatPharo
}

{ #category : #'as yet unclassified' }
TCConsole class >> attach: aTinyChat [
	| window |
	window := self new chat: aTinyChat.
	window openWithSpec whenClosedDo: [ aTinyChat disconnect ].
	^ window
]

{ #category : #'as yet unclassified' }
TCConsole class >> defaultSpec [
	<spec: #default>
	^ SpecLayout composed
		newColumn: [ :c | c add: #list; add: #input height: 30 ]; yourself
]

{ #category : #accessing }
TCConsole >> chat: anObject [
	chat := anObject
]

{ #category : #initialization }
TCConsole >> initializeWidgets [
	list := ListModel new.
	input := TextInputFieldModel new
	ghostText: 'Type your message here...';
	enabled: true;
	acceptBlock: [ :string |
		chat send: string.
		input text: '' ].
	self focusOrder add: input.
]

{ #category : #accessing }
TCConsole >> input [ 
	^ input
]

{ #category : #accessing }
TCConsole >> list [ 
	^ list
]

{ #category : #initialization }
TCConsole >> print: aCollectionOfMessages [
	list items: (aCollectionOfMessages collect: [ :m | m printString])
]

{ #category : #accessing }
TCConsole >> title [ 
	^ 'ChatPharo'
]
