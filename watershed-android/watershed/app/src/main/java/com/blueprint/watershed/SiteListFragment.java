package com.blueprint.watershed;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

public class SiteListFragment extends Fragment implements AbsListView.OnItemClickListener {

    private OnFragmentInteractionListener mListener;

    private ListView mSiteListView;
    private ListAdapter mAdapter;
    private MainActivity mMainActivity;
    private Site[] mSites;


    public static SiteListFragment newInstance(String param1, String param2) {
        return new SiteListFragment();
    }

    public SiteListFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_site_list, container, false);

        setSites(
            new Site[] {
                new Site("Melissa's Home", "A view of Melissa's home."),
                new Site("Andrew's Cave", "This is where Andrew sleeps."),
                new Site("Max's Lair", "Bubble butt"),
                new Site("Jordeen's Street Corner", "-- Melissa")
            }
        );

        mSiteListView = (ListView) view.findViewById(android.R.id.list);

        SiteListAdapter siteListAdapter = new SiteListAdapter(getActivity(), R.layout.site_list_row, getSites());
        mSiteListView.setAdapter(siteListAdapter);

        mSiteListView.setOnItemClickListener(this);
        return view;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mMainActivity = (MainActivity)activity;
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
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (null != mListener) {
            // Load site
            Site site = getSite(position);
            SiteFragment siteFragment = new SiteFragment(site);

            mMainActivity.replaceFragment(siteFragment);
        }
    }

    public void setEmptyText(CharSequence emptyText) {
        View emptyView = mSiteListView.getEmptyView();

        if (emptyText instanceof TextView) {
            ((TextView) emptyView).setText(emptyText);
        }
    }

    public interface OnFragmentInteractionListener {
        public void onFragmentInteraction(String id);
    }

    // Getters
    public Site[] getSites() { return mSites; }
    public Site getSite(int position) { return mSites[position]; }

    // Setters
    public void setSites(Site[] sites) { mSites = sites; }
}
