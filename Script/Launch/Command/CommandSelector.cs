using System;

namespace Launch
{
	public class CommandSelector : CommandContainerBase
	{
		protected CommandBase _selectWork;
		protected CommandBase _succeedWork;
		protected CommandBase _failWork;

		public void AddConditionWork(CommandBase selectWork,CommandBase succeedWork,CommandBase failWork)
		{
			_selectWork = selectWork;
			_succeedWork = succeedWork;
			_failWork = failWork;

			_selectWork.Parent = this;
			if (_succeedWork != null)
			{
				_succeedWork.Parent = this;
			}
			if (_failWork != null)
			{
				_failWork.Parent = this;
			}
		}

		public override void OnChildDone (CommandBase child)
		{
			if (child == this._selectWork) 
			{
				if (this._selectWork.Status == CommandStatus.Succeed) 
				{
					if (_succeedWork != null)
					{
						_succeedWork.OnStart (_context);
					}
					else
					{
						this.OnDone (CommandStatus.Succeed);
					}
				} 
				else 
				{
					if (_failWork != null)
					{
						_failWork.OnStart (_context);
					}
					else
					{
						this.OnDone (CommandStatus.Succeed);
					}
				}
			} 
			else 
			{
				base.OnDone(child.Status);
			}
		}

		public override void OnStart (ICommandContext context)
		{
			base.OnStart (context);
			_selectWork.OnStart (context);
		}

		public override void OnDestroy ()
		{
			base.OnDestroy ();
			if (_succeedWork != null)
			{
				_succeedWork.OnDestroy ();
			}
			if (_failWork != null)
			{
				_failWork.OnDestroy ();
			}
		}
	}
}

