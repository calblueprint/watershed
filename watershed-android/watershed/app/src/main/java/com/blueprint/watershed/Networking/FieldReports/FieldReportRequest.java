package com.blueprint.watershed.Networking.FieldReports;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.Networking.BaseRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

/**
 * Created by Mark Miyashita on 12/08/14.
 */
public class FieldReportRequest extends BaseRequest {

    public FieldReportRequest(final Activity activity, FieldReport fieldReport, HashMap<String, JSONObject> params, final Response.Listener<FieldReport> listener) {
        super(Request.Method.GET, makeObjectURL("field_reports", fieldReport), new JSONObject(params),
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
    }

}
