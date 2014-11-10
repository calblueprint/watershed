package com.blueprint.watershed;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.NetworkError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONArray;

import java.util.HashMap;
import java.util.List;

public class SiteListFragment extends Fragment implements AbsListView.OnItemClickListener {

    private OnFragmentInteractionListener mListener;

    private ListView mSiteListView;
    private ListAdapter mAdapter;
    private SharedPreferences preferences;
    private RequestHandler mRequestHandler;
    private MainActivity mMainActivity;
    private Site[] mSites;


    public static SiteListFragment newInstance(String param1, String param2) {
        return new SiteListFragment();
    }

    public SiteListFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        preferences = getActivity().getSharedPreferences("LOGIN_PREFERENCES", 0);
        mRequestHandler = RequestHandler.getInstance(getActivity().getApplicationContext());
        makeGetSitesRequest();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);

        setSites(
            new Site[] {
                new Site("Melissa's Home", "A view of Melissa's home."),
                new Site("Andrew's Cave", "This is where Andrew sleeps."),
                new Site("Max's Lair", "Bubble butt"),
                new Site("Jordeen's Street Corner", "-- Melissa")
            }
        );

        mSiteListView = (ListView) view.findViewById(android.R.id.list);

        SiteListAdapter siteListAdapter = new SiteListAdapter(getActivity(), R.layout.site_list_row, getSites());
        mSiteListView.setAdapter(siteListAdapter);

        mSiteListView.setOnItemClickListener(this);
        return view;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mMainActivity = (MainActivity)activity;
            mListener = (OnFragmentInteractionListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (null != mListener) {
            // Load site
            Site site = getSite(position);
            SiteFragment siteFragment = new SiteFragment();
            siteFragment.configureWithSite(site);

            mMainActivity.replaceFragment(siteFragment);
        }
    }

    public void makeGetSitesRequest() {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        // TODO(mark): URL and mapper should be generalized
        String url = "https://intense-reaches-1457.herokuapp.com/api/v1/sites";
        final ObjectMapper mapper = new ObjectMapper();
        mapper.setPropertyNamingStrategy(PropertyNamingStrategy.CAMEL_CASE_TO_LOWER_CASE_WITH_UNDERSCORES);

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, new JSONObject(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sitesJson = jsonObject.get("sites").toString();
                            List<Site> sites = mapper.readValue(sitesJson, new TypeReference<List<Site>>() {
                            });
                            //blogListAdapter.setData(BlogListUtil.prependHeader(blogPosts));
                            Log.e("response", jsonObject.toString());
                        } catch (Exception e) {
                            Log.e("Json exception", "in site list fragment" + e.toString());
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        String message;
                        if (volleyError instanceof NetworkError) {
                            message = "Network Error. Please try again later.";
                        }
                        else {
                            try {
                                JSONObject response = new JSONObject(new String(volleyError.networkResponse.data));
                                message = (String) response.get("message");
                            } catch (Exception e) {
                                message = "Unknown Error";
                                e.printStackTrace();
                            }
                        }
                        Context context = getActivity().getApplicationContext();
                        int duration = Toast.LENGTH_SHORT;

                        Toast toast = Toast.makeText(context, message, duration);
                        toast.show();
                    }
                }
        ) {
            // Header params should be generalized into our BaseRequest class
            @Override
            public HashMap<String, String> getHeaders() {
                HashMap<String, String> params = new HashMap<String, String>();
                params.put("X-AUTH-TOKEN", preferences.getString("authentication_token", "none"));
                params.put("X-AUTH-EMAIL", preferences.getString("email", "none"));
                return params;
            }
        };

        mRequestHandler.getRequestQueue().add(request);
    }

    public void setEmptyText(CharSequence emptyText) {
        View emptyView = mSiteListView.getEmptyView();

        if (emptyText instanceof TextView) {
            ((TextView) emptyView).setText(emptyText);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(String id);
    }

    // Getters
    public Site[] getSites() { return mSites; }
    public Site getSite(int position) { return mSites[position]; }

    // Setters
    public void setSites(Site[] sites) { mSites = sites; }
}
