package com.blueprint.watershed.Users;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Users.UsersRequest;
import com.blueprint.watershed.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by charlesx on 4/28/15.
 * Lists all the users for the admin to manage
 */
public class UserListFragment extends Fragment {

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    // Views
    private ListView mListView;
    private UserListAdapter mAdapter;
    private SwipeRefreshLayout mNoUsers;
    private SwipeRefreshLayout mSwipeLayout;

    // Parameters
    private List<User> mUsers;
    private boolean mShouldRequest = false;

    public static UserListFragment newInstance() { return new UserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        mUsers = new ArrayList<User>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_user_list, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initializeViews();
        presetUsers();
    }

    /**
     * Initializes all the views
     */
    private void initializeViews() {
        mAdapter = new UserListAdapter(mParentActivity, mUsers);
        mListView = (ListView) mParentActivity.findViewById(R.id.list);
        mListView.setAdapter(mAdapter);
        mListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                User user = mAdapter.getItem(position);

            }
        });

        mSwipeLayout = (SwipeRefreshLayout) mParentActivity.findViewById(R.id.user_swipe_container);
        mNoUsers = (SwipeRefreshLayout) mParentActivity.findViewById(R.id.no_user_layout);

        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                makeUsersRequest(mSwipeLayout);
            }
        });

        mNoUsers.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mNoUsers.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mNoUsers.setRefreshing(true);
                makeUsersRequest(mNoUsers);
            }
        });
    }

    /**
     * Checks to see if we have to make a request to get all the users.
     */
    private void presetUsers() {
        List<User> users = mParentActivity.getUsers();
        if (users != null && users.size() > 0) setUsers(users);
        else if (!mShouldRequest)makeUsersRequest(null);
    }

    private void makeUsersRequest(final SwipeRefreshLayout layout) {
        UsersRequest request = new UsersRequest(mParentActivity, new Response.Listener<ArrayList<User>>() {
            @Override
            public void onResponse(ArrayList<User> users) {
                if (layout != null) layout.setRefreshing(false);
                setUsers(users);
                if (users.size() > 0) showList();
                else hideList();
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }

    private void setUsers(List<User> users) {
        mUsers.clear();
        mUsers.addAll(users);
        mAdapter.notifyDataSetChanged();
        mShouldRequest = true;
    }

    private void showList() {
        mNoUsers.setVisibility(View.GONE);
        mSwipeLayout.setVisibility(View.VISIBLE);
    }

    private void hideList() {
        mNoUsers.setVisibility(View.VISIBLE);
        mSwipeLayout.setVisibility(View.GONE);
    }

    public static class ChooseActionDialogFragment extends DialogFragment {

        public static ChooseActionDialogFragment newInstance(User user) {
            ChooseActionDialogFragment dialog = new ChooseActionDialogFragment();
            dialog.setUser()
        }

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle(R.string.manage_profile)
                   .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                   dialog.dismiss();
                }
            });
            String[] items = { "Set User to Admin", "Set User to Employee", "Set User to Volunteer", "Delete User"};
            builder.setItems(items, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    sw
                }
            });
        }

        public void setUser(User user) { mUser = user; }
    }

    private void setRole(int 0) {

    }
}
