package com.blueprint.watershed.Users;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.EditUserRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Utilities.Utility;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by charlesx on 2/21/15.
 * Fragment where you can edit a profile
 */
public class EditUserFragment extends Fragment {

    public  static final String PREFERENCES = "WATERSHED_LOGIN_PREFERENCES";

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;
    private User mUser;

    private RelativeLayout mLayout;
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
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        setHasOptionsMenu(true);
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

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }


    /**
     * Initializes the views and sets the fields to the current user's fields.
     */
    private void initializeViews() {
        mLayout = (RelativeLayout) mParentActivity.findViewById(R.id.profile_edit_layout);
        Utility.setKeyboardListener(mParentActivity, mLayout);

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
                Utility.hideKeyboard(mParentActivity, mLayout);
                boolean hasErrors = false;
                if (!mPassword.getText().toString().equals(mReenterPassword.getText().toString())) {
                    mReenterPassword.setError("Your passwords don't match!");
                    hasErrors = true;
                }

                if (mName.getText().toString().isEmpty()) {
                   mName.setError("Name can't be blank!");
                   hasErrors = true;
                }

                Pattern regex = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
                Matcher matcher = regex.matcher(mEmail.getText().toString());
                if (!matcher.find()) {
                    mName.setError("Email must be valid!");
                    hasErrors = true;
                }

                if (hasErrors) return;

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
            object.put("name", mName.getText().toString())
                  .put("email", mEmail.getText().toString())
                  .put("password", mPassword.getText().toString())
                  .put("password_confirmation", mReenterPassword.getText().toString())
                  .put("current_password", mConfirm.getText().toString());
            params.put("user", object);
        } catch (JSONException e) {
            Log.i("JSONException EditUser ", e.toString());
        }

        EditUserRequest request = new EditUserRequest(mParentActivity, mUser, params, new Response.Listener<User>() {
            @Override
            public void onResponse(User user) {
                Utility.hideKeyboard(mParentActivity, mLayout);
                setUserInfo(user);
                mParentActivity.setUser(user);
                mParentActivity.setNavInfo();
                mParentActivity.getSupportFragmentManager().popBackStack();
                Toast.makeText(mParentActivity, "You've updated your profile!", Toast.LENGTH_SHORT).show();
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }

    private void setUserInfo(User user) {
        SharedPreferences.Editor editor = mParentActivity.getSharedPreferences(PREFERENCES, 0).edit();
        editor.putString("email", user.getEmail());
        editor.putInt("userId", user.getId());
        editor.commit();
        mUser.setEmail(user.getEmail());
        mUser.setId(user.getId());
        mUser.setName(user.getName());
        Log.i("saved things", "lol");
    }
}
