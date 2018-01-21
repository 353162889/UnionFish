using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SDKPaySelfInfo
{
    public string Total_fee { get; set; }
    public string Body { get; set; }
    public string PlayerId { get; set; }
    public string Type { get; set; }
    public string GameId { get; set; }

    public override string ToString()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("[SDKPaySelfInfo]");
        sb.Append("Total_fee:");
        sb.Append(Total_fee);
        sb.Append(",Body:");
        sb.Append(Body);
        sb.Append(",PlayerId:");
        sb.Append(PlayerId);
        sb.Append(",Type:");
        sb.Append(Type);
        sb.Append(",GameId:");
        sb.Append(GameId);
        return sb.ToString();
    }
}
