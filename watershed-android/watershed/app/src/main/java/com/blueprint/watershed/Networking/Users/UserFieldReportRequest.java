package com.blueprint.watershed.Networking.Users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.Networking.BaseRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by maxwolffe on 3/16/15.
 */
public class UserFieldReportRequest extends BaseRequest{

    public UserFieldReportRequest(final Activity activity, HashMap<String, JSONObject> params, final Response.Listener<ArrayList<FieldReport>> listener, int id) {
        super(Request.Method.GET, makeUserResourceURL(id, "field_reports"), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sitesJson = jsonObject.get("field_reports").toString();
                            ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                            ArrayList<FieldReport> reports = mapper.readValue(sitesJson, new TypeReference<ArrayList<FieldReport>>() {});
                            listener.onResponse(reports);
                        } catch (Exception e) {
                            Log.e("User MiniSite Json exc", e.toString());
                        }
                    }

                }, activity);
    }
}
