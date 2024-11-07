Class {
	#name : #Chat,
	#superclass : #Object,
	#instVars : [
		'url',
		'login',
		'exit',
		'messages',
		'console',
		'lastMessageIndex'
	],
	#category : #ChatPharo
}

{ #category : #'as yet unclassified' }
Chat class >> connect: aHost port: aPort login: aLogin [
	^ self new
		host: aHost port: aPort login: aLogin;
		start
]

{ #category : #initialization }
Chat >> cmdLastMessageID [
	^ self command: '/messages/count'
]

{ #category : #initialization }
Chat >> cmdMessagesFromLastIndexToEnd [
	"Returns the server messages from my current last index to the last one on the server."
	^ self command: '/messages' argument: lastMessageIndex
]

{ #category : #initialization }
Chat >> cmdNewMessage [
	^self command: '/messages/add'
]

{ #category : #initialization }
Chat >> command: aPath [
	^'{1}{2}' format: { url . aPath }
]

{ #category : #initialization }
Chat >> command: aPath argument: anArgument [
	^'{1}{2}/{3}' format: { url . aPath . anArgument asString }
]

{ #category : #accessing }
Chat >> console [ 
	^console 
]

{ #category : #initialization }
Chat >> disconnect [
	self sendNewMessage: (TCMessage from: login text: 'I exited from the chat room.').
	exit := true
]

{ #category : #accessing }
Chat >> exit [ 
	^ exit
]

{ #category : #'as yet unclassified' }
Chat >> host: aHost port: aPort login: aLogin [
	url := 'http://' , aHost , ':' , aPort asString.
	login := aLogin
]

{ #category : #initialization }
Chat >> initialize [
	super initialize.
	exit := false.
	lastMessageIndex := 0.
	messages := OrderedCollection new.
]

{ #category : #accessing }
Chat >> lastMessageIndex [
	^ lastMessageIndex 	
]

{ #category : #accessing }
Chat >> login [ 
	^login 
	
]

{ #category : #accessing }
Chat >> messages [ 	
	^ messages
]

{ #category : #initialization }
Chat >> readLastMessageID [
	| id |
	id := (ZnClient new url: self cmdLastMessageID; get) asInteger.
	id = 0 ifTrue: [ id := 1 ].
	^ id
]

{ #category : #initialization }
Chat >> readMissingMessages [
	"Gets the new messages that have been posted since the last request."
	| response receivedMessages |
	response := (ZnClient new url: self cmdMessagesFromLastIndexToEnd; get).
	^ response
		ifNil: [ 0 ]
		ifNotNil: [
			receivedMessages := response substrings: (String crlf).
			receivedMessages do: [ :msg | messages add: (TCMessage fromString: msg) ].
			receivedMessages size.
		].
]

{ #category : #initialization }
Chat >> refreshMessages [
	[
		[ exit ] whileFalse: [
		(Delay forSeconds: 2) wait.
		lastMessageIndex := lastMessageIndex + (self
		readMissingMessages).
		console print: messages.
		]
	] fork
]

{ #category : #initialization }
Chat >> send: aString [
	"When we send a message, we push it to the server and in addition we update the local list of posted messages."
	| msg |
	msg := TCMessage from: login text: aString.
	self sendNewMessage: msg.
	lastMessageIndex := lastMessageIndex + (self readMissingMessages).
	console print: messages.
]

{ #category : #initialization }
Chat >> sendNewMessage: aMessage [
	^ ZnClient new
		url: self cmdNewMessage;
		formAt: 'sender' put: (aMessage sender);
		formAt: 'text' put: (aMessage text);
		post
]

{ #category : #'as yet unclassified' }
Chat >> start [
	console := TCConsole attach: self.
	self sendNewMessage: (TCMessage from: login text: 'I joined the chat room').
	lastMessageIndex := self readLastMessageID.
	self refreshMessages.
]

{ #category : #accessing }
Chat >> url [ 
	^url
]
