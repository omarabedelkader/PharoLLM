Class {
	#name : #TCMessage,
	#superclass : #Object,
	#instVars : [
		'sender',
		'text',
		'separator',
		'teapotServer'
	],
	#category : 'ChatPharo'
}

{ #category : #'instance creation' }
TCMessage class >> from: aSender text: aText [
	^ self new sender: aSender; text: aText; yourself
]

{ #category : #'instance creation' }
TCMessage class >> fromString: aString [
	^ self new
	fromString: aString;
	yourself
]

{ #category : #'instance creation' }
TCMessage >> fromString: aString [
	"Compose a message from a string of this form 'sender>message'."
	| items |
	items := aString substrings: separator.
	self sender: items first.
	self text: items second.
]

{ #category : #accessing }
TCMessage >> initialize [ 
	super initialize.
	separator := '>'
]

{ #category : #accessing }
TCMessage >> printOn: aStream [
	aStream
	<< self sender; << separator;
	<< self text; << String crlf
]

{ #category : #accessing }
TCMessage >> sender [
	^sender
]

{ #category : #accessing }
TCMessage >> sender: anObject [
	^sender := anObject 
]

{ #category : #accessing }
TCMessage >> text [
	^text
]

{ #category : #accessing }
TCMessage >> text: anObject [
	^text := anObject
]
