package com.blueprint.watershed.Sites;

import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.AbstractFragments.FloatingActionMenuAbstractFragment;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.MiniSites.CreateMiniSiteFragment;
import com.blueprint.watershed.MiniSites.MiniSite;
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
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;


public class SiteFragment extends FloatingActionMenuAbstractFragment {

    private NetworkManager mNetworkManager;
    private MainActivity mParentActivity;

    private HeaderGridView mMiniSiteGridView;
    private MiniSiteListAdapter mMiniSiteAdapter;
    private ViewGroup mHeader;

    private User mUser;
    private Site mSite;
    private ArrayList<MiniSite> mMiniSites;

    private TextView mSiteTitle;
    private TextView mSiteDescription;
    private TextView mSiteAddress;
    private Button mShowMore;
    private MapFragment mMapFragment;
    private GoogleMap mMap;

    private Menu mMenu;
    private FloatingActionButton mCreateMiniSite;

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
        mSiteDescription.setText(site.getTrimmedText());

        if (site.shouldShowDescriptionDialog()) {
            mShowMore = (Button) view.findViewById(R.id.read_more);
            mShowMore.setVisibility(View.VISIBLE);
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

        mMapFragment = (MapFragment) mParentActivity.getFragmentManager().findFragmentById(R.id.site_map);
        mMapFragment.getMapAsync(mParentActivity);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mParentActivity = (MainActivity) getActivity();
        mUser = mParentActivity.getUser();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_site, container, false);
        initializeViews(view);
        Site site = mParentActivity.getSite();
        if (site != null) {
            mSite = site;
            mParentActivity.setSite(null);
            setMiniSites(mSite.getMiniSites());
            mMiniSiteAdapter.notifyDataSetChanged();
        }
        getSiteRequest(mSite);
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        if (mParentActivity.getUser().isManager()) {
            inflater.inflate(R.menu.site_manager, menu);
        }
        else {
            inflater.inflate(R.menu.site_member, menu);
        }
        mMenu = menu;
        setSubscribedButton(mSite.getSubscribed());
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.subscribe:
                if (!mSite.getSubscribed()) subscribeToSite();
                else unsubscribeFromSite();
                break;
            case R.id.edit:
                editSite();
                break;
            case R.id.delete:
                deleteSiteRequest();
                break;
        }
        return super.onOptionsItemSelected(item);
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

        mMiniSiteAdapter = new MiniSiteListAdapter(mParentActivity, getMiniSites(), mSite);
        mMiniSiteGridView.setAdapter(mMiniSiteAdapter);

        if (mParentActivity.getUser().isManager()) {
            mCreateMiniSite = (FloatingActionButton) view.findViewById(R.id.site_add_minisite);
            mCreateMiniSite.setVisibility(View.VISIBLE);
            mCreateMiniSite.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    mParentActivity.replaceFragment(CreateMiniSiteFragment.newInstance(mSite));
                }
            });
        }
    }

    private void subscribeToSite() {
        SiteSubscribeRequest subRequest =
            new SiteSubscribeRequest(mParentActivity, mSite, new HashMap<String, JSONObject>(), new Response.Listener<String>() {
            @Override
            public void onResponse(String message) {
                mSite.setSubscribed(true);
                setSubscribedButton(mSite.getSubscribed());
            }
        }, mSite.getSubscribed());
        mNetworkManager.getRequestQueue().add(subRequest);
    }

    private void unsubscribeFromSite() {
        SiteSubscribeRequest subRequest =
            new SiteSubscribeRequest(mParentActivity, mSite, new HashMap<String, JSONObject>(), new Response.Listener<String>() {
                @Override
                public void onResponse(String message) {
                    mSite.setSubscribed(false);
                    setSubscribedButton(mSite.getSubscribed());
                }
        }, mSite.getSubscribed());
        mNetworkManager.getRequestQueue().add(subRequest);
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
        setSubscribedButton(site.getSubscribed());
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

    private void setSubscribedButton(boolean showSubscribed) {
        if (showSubscribed) {
            mMenu.findItem(R.id.subscribe).setIcon(R.drawable.ic_bookmark_white_36dp);
        } else {
            mMenu.findItem(R.id.subscribe).setIcon(R.drawable.ic_bookmark_outline_white_36dp);
        }
    }
}