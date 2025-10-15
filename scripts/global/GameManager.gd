extends Node

signal DestruirBuild

enum  State {
	Play,
	Buildling,
	Destroying
}

var CurrentState := State.Play

var not_interaction_world : bool = true
