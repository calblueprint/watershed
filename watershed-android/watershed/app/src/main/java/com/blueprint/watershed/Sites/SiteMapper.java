package com.blueprint.watershed.Sites;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by charlesx on 3/2/15.
 * Data Structure that maps sites to positions
 */
public class SiteMapper {

    private HashMap<Integer, Integer> mIdToPosition;
    private HashMap<Integer, Site> mPositionToSite;

    public SiteMapper() {
        mIdToPosition = new HashMap<Integer, Integer>();
        mPositionToSite = new HashMap<Integer, Site>();
    }

    public Site getSiteWithId(int id) { return mPositionToSite.get(mIdToPosition.get(id)); }

    public Site getSiteWithPosition(int position) { return mPositionToSite.get(position); }

    public int getPositionWithSite(Site site) { return mIdToPosition.get(site.getId()); }

    public void addSite(Site site, int position) {
       mIdToPosition.put(site.getId(), position);
       mPositionToSite.put(position, site);
    }

    public void setSites(ArrayList<Site> sites) {
        for (int i = 0; i < sites.size(); i++) {
            Site site = sites.get(i);
            mIdToPosition.put(site.getId(), i);
            mPositionToSite.put(i, site);
        }
    }

    public void clear() {
        mIdToPosition.clear();
        mPositionToSite.clear();
    }

    public int size() { return mPositionToSite.size(); }
}
