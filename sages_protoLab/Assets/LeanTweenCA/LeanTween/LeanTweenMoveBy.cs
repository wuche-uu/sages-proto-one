using UnityEngine;
using HutongGames.PlayMaker;

namespace HutongGames.PlayMaker.Actions
{
	
	[ActionCategory("LeanTween")]
	[Tooltip("Move a GameObject to a certain location")]
	public class LeanTweenMoveBy : FsmStateAction
	{
		public enum LTLoop
		{
			once,
			clamp,
			pingpong
		}
		[RequiredField]
		[Tooltip("Gameobject that you wish to move.")]
		public FsmOwnerDefault gameObject;
		
		[RequiredField]
		[Tooltip("To The final position with which to move by")]
		public FsmVector3 vector;
		
		[Tooltip("time The time to complete the tween in")]
		public FsmFloat time;
		
		[ActionSection("Optional Parameters")]
		
		[Tooltip("Set the type of easing used for the tween")]
		public LeanTweenType easeType;
		
		[Tooltip("Delay the start of a tween")]
		public FsmFloat delay;
		
		[Tooltip("Set the tween to repeat a number of times")]
		public FsmInt noOfRepeat;
		
		[Tooltip("Set Loop Type of repeat")]
		public LTLoop LoopType;
		
		[Tooltip("Use estimated time when tweening an object.")]
		public FsmBool useEstimatedTime;
		
		[Tooltip("Use frames when tweening an object")]
		public FsmBool useFrames;
		
		[ActionSection("Send Event")]

		[Tooltip("Have a Event called when the tween starts")]
		public FsmEvent onStartEvent;

		[Tooltip("Have a Event called when the tween finishes")]
		public FsmEvent onCompleteEvent;
		
		public FsmEventTarget onUpdateEventTarget;
		
		[Tooltip("Have a method called on each frame that the tween is being animated")]
		public FsmEvent onUpdateEvent;

		[ActionSection("Get Reference")]
		public FsmInt LeanTweenID;
		
		public override void Reset()
		{
			gameObject = null;
			vector = Vector3.zero;
			time = 0f;
			delay = 0f;
			noOfRepeat = 0;
			useEstimatedTime = false;
			useFrames = false;
			
			onUpdateEventTarget = null;
			onUpdateEvent = null;
		}
		// Code that runs on entering the state.
		public override void OnEnter()
		{
			GameObject go = Fsm.GetOwnerDefaultTarget(gameObject);

			Vector3 final = go.transform.localPosition + vector.Value;

			Fsm.Event (onStartEvent);

			LTDescr tween  = LeanTween.moveLocal(go, final, time.Value);
			
			LeanTweenID.Value = tween.id;
			
			tween.setEase(easeType);
			tween.setDelay (delay.Value);
			
			if (noOfRepeat.Value > 0) tween.setRepeat(noOfRepeat.Value);
			
			switch (LoopType)
			{
			case LTLoop.clamp:
				tween.setLoopClamp();
				break;
			case LTLoop.once:
				tween.setLoopOnce();
				break;
			case LTLoop.pingpong:
				tween.setLoopPingPong();
				break;
			}
			
			tween.setOnComplete(doOnComplete);
			tween.setOnUpdate(doOnUpdate);
			tween.setUseEstimatedTime(useEstimatedTime.Value);
			tween.setUseFrames(useFrames.Value);

		}
		
		public void doOnComplete()
		{
			Fsm.Event (onCompleteEvent);
			return;
		}
		
		public void doOnUpdate(float nullFloat)
		{
			Fsm.Event(onUpdateEventTarget, onUpdateEvent);
			return;
		}
		
	}
	
}