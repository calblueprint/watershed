package com.blueprint.watershed.Users;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UserRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

public class ProfileFragment extends Fragment {
    private OnFragmentInteractionListener mListener;
    private User mUser;
    private Activity mMainActivity;
    private NetworkManager mNetworkManager;
    private ProfileOptionsAdapter mAdapter;

    public static ProfileFragment newInstance(User user) {
        ProfileFragment fragment = new ProfileFragment();
        Log.e("Print User", user.toString());
        fragment.setUser(user);
        return fragment;
    }

    public ProfileFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mMainActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    // Networking
    public void makeUserRequest(User user) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        UserRequest userRequest= new UserRequest(getActivity(), user, params, new Response.Listener<User>() {
            @Override
            public void onResponse(User user) {
                setUser(user);
            }
        });

        mNetworkManager.getRequestQueue().add(userRequest);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_profile, container, false);
        configureViewWithUser(view);
        ListView list = (ListView) view.findViewById(R.id.profile_options);
        ArrayList<String> options;
        options = new ArrayList <String>();
        options.add("Field-Reports " + mUser.getFieldReportsCount());
        if (mUser.isEmployee() || mUser.isManager()){
            options.add("Tasks " + mUser.getFieldReportsCount());
            options.add("Sites " + mUser.getSitesCount());
        }

        mAdapter = new ProfileOptionsAdapter(getActivity(), R.layout.option_item, options);
        list.setAdapter(mAdapter);


        return view;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
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
    public void onResume(){
        super.onResume();
        makeUserRequest(mUser);
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    public void configureProfilewithUser(User user) {
        mUser = user;
    }

    public void makeAllUserView(){

    }

    public void makeAdminUserView(){

    }

    public void configureViewWithUser(View view){
        ((TextView)view.findViewById(R.id.profile_name)).setText(mUser.getName());
        ((TextView)view.findViewById(R.id.profile_email)).setText(mUser.getEmail());
        TextView roleView = ((TextView)view.findViewById(R.id.profile_role));
        if (mUser.isCommunityMember()) {
            roleView.setText("Community Member");
        }
        else if (mUser.isEmployee()) {
            roleView.setText("Employee");
        }
        else {
            roleView.setText("Manager");
        }
    }

    public void setUser(User user) { mUser = user; }

}
