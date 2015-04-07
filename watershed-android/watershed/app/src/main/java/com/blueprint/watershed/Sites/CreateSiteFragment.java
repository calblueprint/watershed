package com.blueprint.watershed.Sites;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Network;
import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Tasks.CreateTaskRequest;
import com.blueprint.watershed.R;
import android.support.v4.app.Fragment;
import android.widget.Button;
import android.widget.EditText;

import com.blueprint.watershed.Networking.Sites.CreateSiteRequest;
import com.blueprint.watershed.Tasks.Task;

import org.json.JSONObject;

import java.util.HashMap;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * to handle interaction events.
 * Use the {@link CreateSiteFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CreateSiteFragment extends SiteAbstractFragment implements View.OnClickListener{

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateSiteFragment.
     */
    public static CreateSiteFragment newInstance() { return new CreateSiteFragment(); }

    public CreateSiteFragment() { }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_site, container, false);
        setButtonListeners(view);
        return view;
    }



}
