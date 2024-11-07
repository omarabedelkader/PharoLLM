Class {
	#name : #TCServer,
	#superclass : #Object,
	#instVars : [
		'teapotServer',
		'messagesQueue'
	],
	#category : 'ChatPharo'
}

{ #category : #public }
TCServer class >> startOn: aPortNumber [
	^self new
		initializePort: aPortNumber;
		registerRoutes;
		registerErrorHandlers;
		yourself
]

{ #category : #registration }
TCServer class >> stopAll [
	self allInstancesDo: #stop
]

{ #category : #adding }
TCServer >> addMessage: aRequest [
	messagesQueue add: (TCMessage from: (aRequest at: #sender) text:(aRequest at: #text)).
]

{ #category : #initialization }
TCServer >> initialize [
	super initialize.
	messagesQueue := TCMessageQueue new.
]

{ #category : #initialization }
TCServer >> initializePort: anInteger [
	teapotServer := Teapot configure: {
		#defaultOutput -> #text.
		#port -> anInteger.
		#debugMode -> true
	}.
	teapotServer start.
]

{ #category : #adding }
TCServer >> messageCount [
	^ messagesQueue size
]

{ #category : #adding }
TCServer >> messagesFrom: request [
	^ messagesQueue formattedMessagesFrom: (request at: #id)
]

{ #category : #accessing }
TCServer >> messagesQueue [
	^ messagesQueue
]

{ #category : #initialization }
TCServer >> registerErrorHandlers [
	teapotServer
		exception: KeyNotFound -> (TeaResponse notFound body: 'No such message')
]

{ #category : #initialization }
TCServer >> registerRoutes [
	teapotServer
		GET: '/messages/count' -> (Send message: #messageCount to: self);
		GET: '/messages/<id:IsInteger>' -> (Send message: #messagesFrom: to: self);
		POST: '/messages/add' -> (Send message: #addMessage: to: self)
]

{ #category : #accessing }
TCServer >> stop [
	teapotServer stop.
	messagesQueue reset.
]

{ #category : #accessing }
TCServer >> teapotServer [
	^ teapotServer
]
