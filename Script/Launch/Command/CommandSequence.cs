using System;
using System.Collections.Generic;

namespace Launch
{
	public class CommandSequence : CommandContainerBase
	{
		protected List<CommandBase> _children = new List<CommandBase>();
		protected int _curIndex = -1;  

		public override void OnStart (ICommandContext context)
		{
			base.OnStart (context);
			_curIndex = -1;
			if (_curIndex == _children.Count - 1)
			{
				base.OnDone(CommandStatus.Succeed);
			}
			else
			{
				Next();
			}
		}
		protected void Next()
		{
			if (++_curIndex < _children.Count) 
			{
				CommandBase child = _children [_curIndex];
				child.OnStart (_context);
			}
		}

		public override void OnChildDone (CommandBase cmd)
		{
			if (cmd.Status == CommandStatus.Succeed) 
			{
				if(_curIndex == _children.Count - 1)
				{
					base.OnDone (CommandStatus.Succeed);
				}
				else
				{
					Next();
				}
			} 
			else 
			{
				base.OnDone(CommandStatus.Fail);
			}
		}

		public virtual void AddCmd(CommandBase cmd)
		{
			_children.Add (cmd);
			cmd.Parent = this;
		}

		public override void OnDestroy ()
		{
			if (_children != null) 
			{
				int count = _children.Count;
				for(int i = 0; i < count; ++i)
				{
					_children[i].OnDestroy();
				}

				_children.Clear ();
				_children = null;
			}
			base.OnDestroy ();
		}
	}
}

