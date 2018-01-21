package com.kogarasi.unity.webview;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.apache.http.util.EncodingUtils;

import com.unity3d.player.UnityPlayer;

import android.app.Activity;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.webkit.WebView;
import android.widget.FrameLayout;

public class WebViewPlugin
{
	private static FrameLayout layout = null;
	private WebView mWebView;
	private String gameObject;

	public WebViewPlugin(){}

	public void Init(final String gameObject)
	{
		this.gameObject = gameObject;
		final Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {
			
			mWebView = WebViewFactory.Create( a, gameObject );
			
			if ( layout == null ) {
				layout = new FrameLayout(a);
				a.addContentView(layout, new LayoutParams(
					LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
				layout.setFocusable(true);
				layout.setFocusableInTouchMode(true);
			}

			layout.addView(mWebView, new FrameLayout.LayoutParams(
				LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT,
				Gravity.NO_GRAVITY));
			
		}});
	}

	public void Destroy()
	{
		Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {

			if (mWebView != null) {
				layout.removeView(mWebView);
				mWebView = null;
			}

		}});
	}

	public void LoadURL(final String url)
	{
		final Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {
			mWebView.loadUrl(url);
		}});
	}
	
	public void PostURL(final String url,final String param)
	{
		final Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {
			UnityPlayer.UnitySendMessage( gameObject, "OnAppLog", "url:"+url+",param:"+param );
			String realParam = "";
			if(param != null)
			{
				String[] arr = param.split("&");
				if(arr != null)
				{
					for(int i = 0;i < arr.length;i++)
					{
						String[] subArr = arr[i].split("=");
						String key = subArr[0];
						String value = subArr[1];
						try {
							value = URLEncoder.encode(value, "UTF-8");
						} catch (UnsupportedEncodingException e) {
							// TODO Auto-generated catch block
							UnityPlayer.UnitySendMessage( gameObject, "OnAppLog", "UnsupportedEncodingException:"+e.toString());
							e.printStackTrace();
						}
						if(i == 0)
						{
							realParam += String.format("%s=%s",key,value);
						}
						else
						{
							realParam += String.format("&%s=%s", key,value);
						}
					}
				}
				
			}
			realParam = realParam.replace("\\+", "%2B");
			UnityPlayer.UnitySendMessage( gameObject, "OnAppLog", "url:"+url+",realParam:"+realParam );
			mWebView.postUrl(url, EncodingUtils.getBytes(realParam, "UTF-8"));
		}});
	}

	public void SetMargins(int left, int top, int right, int bottom)
	{
		final FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
			LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT,
				Gravity.NO_GRAVITY);
		params.setMargins(left, top, right, bottom);

		Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {

			mWebView.setLayoutParams(params);

		}});
	}

	public void SetVisibility(final boolean visibility)
	{
		Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {

			if (visibility) {
				mWebView.setVisibility(View.VISIBLE);
				layout.requestFocus();
				mWebView.requestFocus();
			} else {
				mWebView.setVisibility(View.GONE);
			}

		}});
	}
	
	public void ClearView()
	{
		Activity a = UnityPlayer.currentActivity;
		a.runOnUiThread(new Runnable() {public void run() {

			if(mWebView == null)return;
			mWebView.clearView();

		}});
	}
	
}
