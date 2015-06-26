package com.blueprint.watershed.Sites.SiteList;

import com.blueprint.watershed.Sites.Site;

/**
 * Created by charlesx on 6/18/15.
 */
public class SiteEvent {

    private Site site;
    private SiteEnum type;

    public SiteEvent(Site site, SiteEnum type) {
        this.site = site;
        this.type = type;
    }

    public Site getSite() {
        return site;
    }

    public SiteEnum getType() {
        return type;
    }
}
