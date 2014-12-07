package com.blueprint.watershed.Users;

import android.app.Activity;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UserRequest;
import com.blueprint.watershed.R;

import org.json.JSONObject;

import java.util.HashMap;

public class ProfileFragment extends Fragment {
    private OnFragmentInteractionListener mListener;
    private User mUser;
    private Activity mMainActivity;
    private NetworkManager mNetworkManager;

    public static ProfileFragment newInstance(User user) {
        ProfileFragment fragment = new ProfileFragment();
        fragment.setUser(user);
        return fragment;
    }

    public ProfileFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUser = new User();
        mMainActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }

    // Networking
    public void getUserRequest(User user) {
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

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(Uri uri);
    }

    public void configureProfilewithUser(User user) {
        mUser = user;
        //Make a Request for Field Reports maybe. Depends on how we are going to show things
    }

    public void configureViewWithUser(View view, User user){
        ((TextView)view.findViewById(R.id.profile_name)).setText(mUser.getName());
        ((TextView)view.findViewById(R.id.profile_email)).setText(mUser.getEmail());
        //((TextView)view.findViewById(R.id.profile_role)).setText(mUser.getRole());

    }

    public void setUser(User user) { mUser = user; }

}
