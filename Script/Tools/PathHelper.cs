using UnityEngine;
using System.Collections;
using System;


/// <summary>
/// Catmull-Rom插值算法，取自iTween
/// </summary>
public class PathHelper
{

    public static void DrawPath(Vector3[] path, Color color)
    {
        if (path.Length > 0)
        {
            DrawPathHelper(path, color);
        }
    }

    public static Vector3[] GetPathAllPos(Vector3[] path, int pointCount)
    {
        Vector3[] vector3s = PathControlPointGenerator(path);
        Vector3 prevPt = Interp(vector3s, 0);
        int SmoothAmount = path.Length * pointCount;
        Vector3[] tmpArr = new Vector3[SmoothAmount + 1];
        tmpArr[0] = prevPt;
        for (int i = 1; i <= SmoothAmount; i++)
        {
            float pm = (float)i / SmoothAmount;
            Vector3 currPt = Interp(vector3s, pm);
            prevPt = currPt;
            tmpArr[i] = currPt;
        }
        return tmpArr;
    }


    private static void DrawPathHelper(Vector3[] path, Color color)
    {
        Vector3[] vector3s = PathControlPointGenerator(path);

        //Line Draw:
        Vector3 prevPt = Interp(vector3s, 0);
        Gizmos.color = color;
        //int SmoothAmount = path.Length * 3;
        int SmoothAmount = path.Length * 15;
        for (int i = 1; i <= SmoothAmount; i++)
        {
            float pm = (float)i / SmoothAmount;
            Vector3 currPt = Interp(vector3s, pm);
            Gizmos.DrawLine(currPt, prevPt);
            prevPt = currPt;
        }

    }


    private static Vector3[] PathControlPointGenerator(Vector3[] path)
    {
        Vector3[] suppliedPath;
        Vector3[] vector3s;

        //create and store path points:
        suppliedPath = path;

        //populate calculate path;
        int offset = 2;
        vector3s = new Vector3[suppliedPath.Length + offset];
        Array.Copy(suppliedPath, 0, vector3s, 1, suppliedPath.Length);

        //populate start and end control points:
        //vector3s[0] = vector3s[1] - vector3s[2];
        vector3s[0] = vector3s[1] + (vector3s[1] - vector3s[2]);
        vector3s[vector3s.Length - 1] = vector3s[vector3s.Length - 2] + (vector3s[vector3s.Length - 2] - vector3s[vector3s.Length - 3]);

        //is this a closed, continuous loop? yes? well then so let's make a continuous Catmull-Rom spline!
        if (vector3s[1] == vector3s[vector3s.Length - 2])
        {
            Vector3[] tmpLoopSpline = new Vector3[vector3s.Length];
            Array.Copy(vector3s, tmpLoopSpline, vector3s.Length);
            tmpLoopSpline[0] = tmpLoopSpline[tmpLoopSpline.Length - 3];
            tmpLoopSpline[tmpLoopSpline.Length - 1] = tmpLoopSpline[2];
            vector3s = new Vector3[tmpLoopSpline.Length];
            Array.Copy(tmpLoopSpline, vector3s, tmpLoopSpline.Length);
        }

        return (vector3s);
    }

    private static Vector3 Interp(Vector3[] pts, float t)
    {
        int numSections = pts.Length - 3;
        int currPt = Mathf.Min(Mathf.FloorToInt(t * (float)numSections), numSections - 1);
        float u = t * (float)numSections - (float)currPt;

        Vector3 a = pts[currPt];
        Vector3 b = pts[currPt + 1];
        Vector3 c = pts[currPt + 2];
        Vector3 d = pts[currPt + 3];

        return .5f * (
            (-a + 3f * b - 3f * c + d) * (u * u * u)
            + (2f * a - 5f * b + 4f * c - d) * (u * u)
            + (-a + c) * u
            + 2f * b
        );
    }


}
