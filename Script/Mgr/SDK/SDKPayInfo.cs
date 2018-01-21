using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class SDKPayInfo
{
    public string ProductId { get; set; }
    public string ProductName { get; set; }
    public string ProductPrice { get; set; }
    public string ProductCount { get; set; }
    public string ProductDesc { get; set; }
    public string CoinName { get; set; }
    public string CoinRate { get; set; }
    public string RoleId { get; set; }
    public string RoleName { get; set; }
    public string RoleGrade { get; set; }
    public string RoleBalance { get; set; }
    public string VIPLevel { get; set; }
    public string PartyName { get; set; }
    public string ServerId { get; set; }
    public string ServerName { get; set; }
    public string Ext { get; set; }

    public SDKPayInfo()
    {

    }

    public override string ToString()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("[SDKPayInfo]");
        sb.Append("ProductId:");
        sb.Append(ProductId);
        sb.Append(",ProductName:");
        sb.Append(ProductName);
        sb.Append(",ProductPrice:");
        sb.Append(ProductPrice);
        sb.Append(",ProductCount:");
        sb.Append(ProductCount);
        sb.Append(",ProductDesc:");
        sb.Append(ProductDesc);
        sb.Append(",CoinName:");
        sb.Append(CoinName);
        sb.Append(",CoinRate:");
        sb.Append(CoinRate);
        sb.Append(",RoleId:");
        sb.Append(RoleId);
        sb.Append(",RoleName:");
        sb.Append(RoleName);
        sb.Append(",RoleGrade:");
        sb.Append(RoleGrade);
        sb.Append(",RoleBalance:");
        sb.Append(RoleBalance);
        sb.Append(",VIPLevel:");
        sb.Append(VIPLevel);
        sb.Append(",PartyName:");
        sb.Append(PartyName);
        sb.Append(",ServerId:");
        sb.Append(ServerId);
        sb.Append(",ServerName:");
        sb.Append(ServerName);
        sb.Append(",Ext:");
        sb.Append(Ext);
        return sb.ToString();
    }
}
