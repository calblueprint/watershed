package com.blueprint.watershed.Sites;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.AbstractFragments.FloatingActionMenuAbstractFragment;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.CreateMiniSiteFragment;
import com.blueprint.watershed.MiniSites.MiniSite;
import com.blueprint.watershed.MiniSites.MiniSiteFragment;
import com.blueprint.watershed.MiniSites.MiniSiteListAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Networking.Sites.DeleteSiteRequest;
import com.blueprint.watershed.Networking.Sites.SiteRequest;
import com.blueprint.watershed.Networking.Sites.SiteSubscribeRequest;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Users.User;
import com.blueprint.watershed.Utilities.Utility;
import com.blueprint.watershed.Views.HeaderGridView;
import com.blueprint.watershed.Views.Material.FloatingActionButton;
import com.blueprint.watershed.Views.Material.FloatingActionsMenu;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class SiteFragment extends FloatingActionMenuAbstractFragment
                          implements AbsListView.OnItemClickListener {

    private NetworkManager mNetworkManager;
    private MainActivity mParentActivity;

    private HeaderGridView mMiniSiteGridView;
    private MiniSiteListAdapter mMiniSiteAdapter;
    private ViewGroup mHeader;

    private User mUser;
    private Site mSite;
    private ArrayList<MiniSite> mMiniSites;
    private View mView;

    private TextView mSiteTitle;
    private TextView mSiteDescription;
    private TextView mSiteAddress;
    private Button mShowMore;

    FloatingActionButton mSubscribeButton;

    public static SiteFragment newInstance(Site site) {
        SiteFragment siteFragment = new SiteFragment();
        siteFragment.configureWithSite(site);
        return siteFragment;
    }

    public void configureWithSite(Site site) { mSite = site; }

    public void configureViewWithSite(View view, final Site site) {
        mSiteTitle = (TextView) view.findViewById(R.id.site_name);
        mSiteTitle.setText(site.getName());

        mSiteDescription = (TextView) view.findViewById(R.id.site_description);
        mShowMore = (Button) view.findViewById(R.id.read_more);
        mSiteDescription.setText(site.getTrimmedText());

        if (site.shouldShowDescriptionDialog()) {
            mShowMore.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Utility.showAndBuildDialog(mParentActivity, null, site.getDescription(), "Back", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    }, null);
                }
            });
        }

        mSiteAddress = (TextView) view.findViewById(R.id.site_location);
        mSiteAddress.setText(site.getLocationOneLine());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mUser = mParentActivity.getUser();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_site, container, false);
        mView = view;
        initializeViews(view);
        Site site = mParentActivity.getSite();
        if (site != null) {
            mSite = site;
            mParentActivity.setSite(null);
            setMiniSites(mSite.getMiniSites());
            mMiniSiteAdapter.notifyDataSetChanged();
        }
        if (mSite.isMiniSiteEmpty()) getSiteRequest(mSite);
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.delete_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.delete:
                deleteSiteRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    private void initializeViews(View view) {
        // Create MiniSite grid
        mMiniSiteGridView = (HeaderGridView) view.findViewById(R.id.mini_sites_grid);
        mHeader = (ViewGroup) mParentActivity.getLayoutInflater().inflate(R.layout.site_header_view, mMiniSiteGridView, false);
        mMiniSiteGridView.addHeaderView(mHeader, null, false);
        configureViewWithSite(mHeader, mSite);


        // Set the adapter to fill the list of mini sites
        mMiniSiteAdapter = new MiniSiteListAdapter(mParentActivity, getMiniSites(), mSite);
        mMiniSiteGridView.setAdapter(mMiniSiteAdapter);
        mMiniSiteGridView.setOnItemClickListener(this);

        mSubscribeButton = (FloatingActionButton) mView.findViewById(R.id.site_subscribe_site);
        if (mSite.getSubscribed()) {
            mSubscribeButton.setTitle("Unsubscribe from Site");
            mSubscribeButton.setIcon(R.drawable.ic_bookmark_white_36dp);
        }
        else {
            mSubscribeButton.setTitle("Subscribe to Site");
            mSubscribeButton.setIcon(R.drawable.ic_bookmark_outline_white_36dp);
        }

        setButtonListeners(view);
    }

    private void setButtonListeners(View view) {
        mMenu = (FloatingActionsMenu) view.findViewById(R.id.site_settings);
        FloatingActionButton editButton = (FloatingActionButton) view.findViewById(R.id.site_edit_site);
        editButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mMenu.collapse();
                editSite();
            }
        });
        FloatingActionButton miniSiteCreate = (FloatingActionButton) view.findViewById(R.id.site_add_minisite);
        miniSiteCreate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mMenu.collapse();
                mParentActivity.replaceFragment(CreateMiniSiteFragment.newInstance(mSite));
            }
        });

        View subscribeButton = view.findViewById(R.id.site_subscribe_site);
        subscribeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mSite.getSubscribed()) subscribeToSite();
                else unsubscribeFromSite();
            }
        });
    }

    private void subscribeToSite() {
        SiteSubscribeRequest subRequest = new SiteSubscribeRequest(mParentActivity, mSite, new HashMap<String, JSONObject>(), new Response.Listener<String>() {
            @Override
            public void onResponse(String message) {
                mSubscribeButton.setIcon(R.drawable.ic_bookmark_white_36dp);
                mSite.setSubscribed(true);
            }
        }, mSite.getSubscribed());
        mNetworkManager.getRequestQueue().add(subRequest);
    }

    private void unsubscribeFromSite() {
        SiteSubscribeRequest subRequest = new SiteSubscribeRequest(mParentActivity, mSite, new HashMap<String, JSONObject>(), new Response.Listener<String>() {
            @Override
            public void onResponse(String message) {
                mSubscribeButton.setIcon(R.drawable.ic_bookmark_outline_white_36dp);
                mSite.setSubscribed(false);
            }
        }, mSite.getSubscribed());
        mNetworkManager.getRequestQueue().add(subRequest);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        MiniSite miniSite = getMiniSite(position);
        MiniSiteFragment miniSiteFragment = MiniSiteFragment.newInstance(mSite, miniSite);
        mParentActivity.replaceFragment(miniSiteFragment);
    }

    // Networking
    private void getSiteRequest(Site site) {
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();
        SiteRequest siteRequest = new SiteRequest(getActivity(), site, params, new Response.Listener<Site>() {
            @Override
            public void onResponse(Site site) {
                setSite(site);
                mParentActivity.getSpinner().setVisibility(View.GONE);
                mMiniSiteAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(siteRequest);
    }

    private void setSite(Site site) {
        mSite = site;
        setMiniSites(site.getMiniSites());
    }

    private MiniSite getMiniSite(int position) { return mMiniSites.get(position); }

    private ArrayList<MiniSite> getMiniSites() {
        if (mMiniSites == null) mMiniSites = new ArrayList<>();
        return mMiniSites;
    }

    private void setMiniSites(ArrayList<MiniSite> miniSites) {
        if (mMiniSites == null) mMiniSites = new ArrayList<>();
        mMiniSites.clear();
        for (MiniSite miniSite : miniSites) {
            mMiniSites.add(miniSite);
        }
    }

    private void editSite() {
        EditSiteFragment editSiteFragment = EditSiteFragment.newInstance(mSite);
        mParentActivity.replaceFragment(editSiteFragment);
    }

    private void deleteSiteRequest() {
        Utility.showAndBuildDialog(mParentActivity, R.string.site_delete_title, R.string.site_delete_msg,
            new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    makeDeleteSiteRequest();
                }
            }, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
    }

    private void makeDeleteSiteRequest() {
        DeleteSiteRequest request = new DeleteSiteRequest(mParentActivity, mSite, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject jsonObject) {
                mParentActivity.setSite(mSite);
                mParentActivity.getSupportFragmentManager().popBackStack();
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }

    @Override
    public void onPause() {
        super.onDestroy();
        if (mMenu != null) closeMenu();
    }
}