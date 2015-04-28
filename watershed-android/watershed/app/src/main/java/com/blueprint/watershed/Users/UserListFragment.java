package com.blueprint.watershed.Users;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;

import java.util.List;

/**
 * Created by charlesx on 4/28/15.
 * Lists all the users for the admin to manage
 */
public class UserListFragment extends Fragment {

    private MainActivity mParentActivity;
    private NetworkManager mNetworkManager;

    // Views
    protected ListView mListView;
    protected SwipeRefreshLayout mNoUsers;
    protected SwipeRefreshLayout mSwipeLayout;

    //
    private List<User> mUsers;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
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
    }

    private void initializeViews() {
        mListView = (ListView) mParentActivity.findViewById(R.id.list);


        mSwipeLayout = (SwipeRefreshLayout) mParentActivity.findViewById(R.id.user_swipe_container);
        mNoUsers = (SwipeRefreshLayout) mParentActivity.findViewById(R.id.no_user_layout);

        mSwipeLayout.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mSwipeLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                makeUsersRequest();
            }
        });

        mNoUsers.setColorSchemeResources(R.color.ws_blue, R.color.facebook_blue, R.color.facebook_dark_blue, R.color.dark_gray);
        mNoUsers.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                mSwipeLayout.setRefreshing(true);
                makeUsersRequest();
            }
        });
    }

    private void makeUsersRequest() {

    }
}
