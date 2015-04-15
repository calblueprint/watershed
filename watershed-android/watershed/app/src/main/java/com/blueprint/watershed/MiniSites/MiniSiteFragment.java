package com.blueprint.watershed.MiniSites;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.TextView;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.FieldReports.AddFieldReportFragment;
import com.blueprint.watershed.FieldReports.FieldReport;
import com.blueprint.watershed.FieldReports.FieldReportListAdapter;
import com.blueprint.watershed.Networking.MiniSites.DeleteMiniSiteRequest;
import com.blueprint.watershed.Networking.MiniSites.MiniSiteRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Utilities.Utility;
import com.blueprint.watershed.Views.CoverPhotoPagerView;
import com.blueprint.watershed.Views.HeaderGridView;
import com.blueprint.watershed.Views.Material.FloatingActionButton;
import com.blueprint.watershed.Views.Material.FloatingActionsMenu;

import java.util.ArrayList;
import java.util.List;


public class MiniSiteFragment extends Fragment
                              implements AbsListView.OnItemClickListener {

    private NetworkManager mNetworkManager;
    private MainActivity mParentActivity;
    private HeaderGridView mFieldReportGridView;
    private FieldReportListAdapter mFieldReportAdapter;
    private MiniSite mMiniSite;
    private Site mSite;
    private List<FieldReport> mFieldReports;

    // Buttons
    private FloatingActionButton mEditButton;
    private FloatingActionButton mFieldReportButton;
    private FloatingActionsMenu mMenu;

    public static MiniSiteFragment newInstance(Site site, MiniSite miniSite) {
        MiniSiteFragment miniSiteFragment = new MiniSiteFragment();
        miniSiteFragment.setMiniSite(miniSite);
        miniSiteFragment.setSite(site);
        return miniSiteFragment;
    }


    public void setSite(Site site) { mSite = site; }

    // Objects
    public void setMiniSite(MiniSite miniSite) {
        mMiniSite = miniSite;
        setFieldReports(miniSite.getFieldReports());
    }

    public void configureViewWithMiniSite(View view, MiniSite miniSite) {
        ((CoverPhotoPagerView)view.findViewById(R.id.cover_photo_pager_view)).configureWithPhotos(miniSite.getPhotos());
        ((TextView) view.findViewById(R.id.mini_site_name)).setText(miniSite.getName());
        ((TextView) view.findViewById(R.id.mini_site_description)).setText(miniSite.getDescription());
        ((TextView) view.findViewById(R.id.mini_site_location)).setText(miniSite.getLocation());
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_mini_site, container, false);
        initializeViews(view, inflater);
        getMiniSite(mMiniSite);
        return view;
    }

    private void getMiniSite(MiniSite miniSite) {
        MiniSiteRequest request = new MiniSiteRequest(mParentActivity, miniSite, new Response.Listener<MiniSite>() {
            @Override
            public void onResponse(MiniSite miniSite) {
                setFieldReports(miniSite.getFieldReports());
                mFieldReportAdapter.notifyDataSetChanged();
            }
        });

        mNetworkManager.getRequestQueue().add(request);
    }

    private void initializeViews(View view, LayoutInflater inflater) {
        // Create FieldReportGridView
        mFieldReportGridView = (HeaderGridView) view.findViewById(R.id.field_reports_grid);

        // Add mini site header information to the top
        ViewGroup header = (ViewGroup) inflater.inflate(R.layout.mini_site_header_view, mFieldReportGridView, false);
        mFieldReportGridView.addHeaderView(header, null, false);

        // Configure the header
        configureViewWithMiniSite(header, mMiniSite);

        // Set FAB listeners
        setButtonListeners(view);

        // Set the adapter to fill the list of field reports
        mFieldReportAdapter = new FieldReportListAdapter(mParentActivity, mParentActivity, R.layout.field_report_list_row, getFieldReports());
        mFieldReportGridView.setAdapter(mFieldReportAdapter);
        mFieldReportGridView.setOnItemClickListener(this);
    }

    private void setButtonListeners(View view) {
        mMenu = (FloatingActionsMenu) view.findViewById(R.id.mini_site_menu);
        mEditButton = (FloatingActionButton) view.findViewById(R.id.mini_site_edit_minisite);
        mEditButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mParentActivity.replaceFragment(EditMiniSiteFragment.newInstance(mSite, mMiniSite));
            }
        });

        mFieldReportButton = (FloatingActionButton) view.findViewById(R.id.mini_site_add_fieldreport);
        mFieldReportButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Add Field Report. Unless we are requiring a user to be completing a task to submit a report.
            }
        });
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
            case R.id.edit:
                EditMiniSiteFragment fragment = EditMiniSiteFragment.newInstance(mSite, mMiniSite);
                mParentActivity.replaceFragment(fragment);
            case R.id.delete:
                deleteMiniSite();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mParentActivity.setMenuAction(false);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        // Load Field Report
        FieldReport fieldReport = getFieldReport(position);
        AddFieldReportFragment addFieldReportFragment = new AddFieldReportFragment();
        addFieldReportFragment.configureWithFieldReport(fieldReport);
        mParentActivity.replaceFragment(addFieldReportFragment);
    }

    public FieldReport getFieldReport(int position) { return mFieldReports.get(position); }

    public List<FieldReport> getFieldReports() {
        if (mFieldReports == null) mFieldReports = new ArrayList<>();
        return mFieldReports;
    }

    public void setFieldReports(List<FieldReport> fieldReports) {
        if (mFieldReports == null) mFieldReports = new ArrayList<>();
        mFieldReports.clear();
        for (FieldReport fieldReport : fieldReports) {
            mFieldReports.add(fieldReport);
        }
    }

    private void deleteMiniSite() {
        Utility.showAndBuildDialog(mParentActivity, R.string.mini_site_delete_title,
                R.string.mini_site_delete_msg, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        makeDeleteRequest();
                    }
                }, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                }
        );
    }

    private void makeDeleteRequest() {
        DeleteMiniSiteRequest request = new DeleteMiniSiteRequest(mParentActivity, mMiniSite, new Response.Listener<Site>() {
            @Override
            public void onResponse(Site site) {
                mParentActivity.setSite(site);
                mSite = site;
                mParentActivity.getSupportFragmentManager().popBackStack();
            }
        });
        mNetworkManager.getRequestQueue().add(request);
    }

    @Override
    public void onPause() {
        super.onDestroy();
        if (mMenu != null) mMenu.collapse();
    }

    public boolean closeMenu() {
        boolean isOpened = mMenu.isExpanded();
        if (isOpened) mMenu.collapse();
        return isOpened;
    }
}