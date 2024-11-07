Class {
	#name : 'TCConsole',
	#superclass : 'Object',
	#instVars : [
		'chat',
		'list',
		'input'
	],
	#category : 'ChatPharo',
	#package : 'ChatPharo'
}

{ #category : 'as yet unclassified' }
TCConsole class >> attach: aTinyChat [
	| window |
	window := self new chat: aTinyChat.
	window openWithSpec whenClosedDo: [ aTinyChat disconnect ].
	^ window
]

{ #category : 'as yet unclassified' }
TCConsole class >> defaultSpec [
	<spec: #default>
	^ SpBoxLayout composed
		newColumn: [ :c | c add: #list; add: #input height: 30 ]; yourself
]

{ #category : 'accessing' }
TCConsole >> chat: anObject [
	chat := anObject
]

{ #category : 'accessing' }
TCConsole >> input [ 
	^ input
]

{ #category : 'accessing' }
TCConsole >> list [ 
	^ list
]

{ #category : 'accessing' }
TCConsole >> title [ 
	^ 'ChatPharo'
]
