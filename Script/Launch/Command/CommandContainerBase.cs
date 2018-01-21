using System;

namespace Launch
{
	public class CommandContainerBase : CommandBase
	{
		public virtual void OnChildDone(CommandBase cmd)
		{
		}
	}
}

