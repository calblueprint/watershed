package com.blueprint.watershed.Networking.FieldReports;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.Networking.BaseRequest;
import com.blueprint.watershed.Sites.Site;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Mark Miyashita on 11/23/14.
 */
public class CreateFieldReportRequest extends BaseRequest {

    FieldReport mFieldReport;
    Activity mActivity;

    public CreateFieldReportRequest(final Activity activity, final FieldReport fieldReport, HashMap<String, JSONObject> params, final Response.Listener<FieldReport> listener) {
        super(Request.Method.POST, makeURL("field_reports"), new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String fieldReportJson = jsonObject.get("field_report").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            FieldReport fieldReport = mapper.readValue(fieldReportJson, new TypeReference<FieldReport>() {
                            });
                            listener.onResponse(fieldReport);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, activity);
        mFieldReport = fieldReport;
    }

    @Override
    protected HashMap<String,String> getParams(){
        HashMap<String,String> params = new HashMap<String, String>();

        try {
            params.put("field_report", getNetworkManager(mActivity.getApplicationContext()).getObjectMapper().writeValueAsString(mFieldReport));
        } catch (Exception e) {
            // lol
        }

        return params;
    }
}
