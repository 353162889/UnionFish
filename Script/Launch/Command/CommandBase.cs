using System;

namespace Launch
{
	public enum CommandStatus
	{
		Succeed,
		Fail
	}

	public interface ICommandContext
	{
		void Dispose();
	}

	public class CommandBase
	{
		public event Action<CommandBase> OnCmdDone;

		public CommandContainerBase Parent { get; set;}

		protected CommandStatus _status = CommandStatus.Fail;
		public CommandStatus Status { get { return _status; }}

		protected ICommandContext _context;

		protected virtual void OnDone(CommandStatus status)
		{
			_status = status;
            this.OnDoneBefore();
			if (OnCmdDone != null)
			{
				OnCmdDone(this);
			}

			if (Parent != null)
			{
				Parent.OnChildDone (this);
			}
			else
			{
				OnDestroy ();
			}
		}

        //自己执行完成，在告诉父对象执行完成之前
		protected virtual void OnDoneBefore()
		{
		}

		public virtual void OnStart(ICommandContext context)
		{
			_context = context;
		}

		public void OnStart()
		{
			OnStart (null);
		}

		public virtual void OnDestroy()
		{
			if (_context != null)
			{
				_context.Dispose ();
				_context = null;
			}
			OnCmdDone = null;
			Parent = null;
		}
	}
}

