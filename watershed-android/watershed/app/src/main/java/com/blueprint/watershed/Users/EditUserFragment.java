package com.blueprint.watershed.Users;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.EditUserRequest;
import com.blueprint.watershed.R;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by charlesx on 2/21/15.
 * Fragment where you can edit a profile
 */
public class EditUserFragment extends Fragment {

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;
    private User mUser;

    private EditText mName;
    private EditText mEmail;
    private EditText mPassword;
    private EditText mReenterPassword;
    private EditText mConfirm;
    private Button mSubmit;

    public static EditUserFragment newInstance(User user) {
        EditUserFragment fragment = new EditUserFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_edit_user, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
    }

    /**
     * Initializes the views and sets the fields to the current user's fields.
     */
    private void initializeViews() {
        mName = (EditText) mParentActivity.findViewById(R.id.profile_edit_name);
        mEmail = (EditText) mParentActivity.findViewById(R.id.profile_edit_email);
        mPassword = (EditText) mParentActivity.findViewById(R.id.profile_edit_password);
        mReenterPassword = (EditText) mParentActivity.findViewById(R.id.profile_edit_reenter_password);
        mConfirm = (EditText) mParentActivity.findViewById(R.id.profile_edit_confirm_password);

        mName.setText(mUser.getName());
        mEmail.setText(mUser.getEmail());

        mSubmit = (Button) mParentActivity.findViewById(R.id.profile_edit_submit);
        mSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean hasErrors = false;
                if (!mPassword.getText().toString().equals(mReenterPassword.getText().toString())) {
                    mReenterPassword.setError("Your passwords don't match!");
                    hasErrors = true;
                }


                sendEditUserRequest();
            }
        });
    }

    /**
     * Sends request to edit the user.
     */
    private void sendEditUserRequest() {
        JSONObject params = new JSONObject();
        JSONObject object = new JSONObject();
        try {
            object.put("name", mName.getText())
                  .put("email", mEmail.getText())
                  .put("password", mPassword.getText())
                  .put("current_password", mConfirm.getText());
            params.put("user", object);
        } catch (JSONException e) {
            Log.i("JSONException EditUserFragment: ", e.toString());
        }

        EditUserRequest request = new EditUserRequest(mParentActivity, mUser, params, new Response.Listener<User>() {
            @Override
            public void onResponse(User user) {
                Toast.makeText(mParentActivity, "You've updated your profile!", Toast.LENGTH_SHORT).show();
                mParentActivity.replaceFragment(UserFragment.newInstance(user));
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }
}
