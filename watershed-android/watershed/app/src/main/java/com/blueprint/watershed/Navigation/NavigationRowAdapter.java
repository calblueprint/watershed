package com.blueprint.watershed.Navigation;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.blueprint.watershed.R;

import java.util.List;

/**
 * Created by charlesx on 4/28/15.
 */
public class NavigationRowAdapter extends ArrayAdapter<MenuRow> {

    private Activity mActivity;
    private List<MenuRow> mMenuItems;
    private int mResourceId;

    public NavigationRowAdapter(Activity activity, int layoutId, List<MenuRow> menuItems) {
        super(activity, layoutId, menuItems);
        mActivity = activity;
        mMenuItems = menuItems;
        mResourceId = layoutId;
    }

    @Override
    public MenuRow getItem(int position) { return mMenuItems.get(position); }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        MenuViewHolder holder;

        if (row == null) {
            row = mActivity.getLayoutInflater().inflate(mResourceId, parent, false);

            holder = new MenuViewHolder();
            holder.mIcon = (ImageView) row.findViewById(R.id.menu_icon);
            holder.mIndicator = row.findViewById(R.id.menu_indicator);
            holder.mTitle = (TextView) row.findViewById(R.id.menu_title);

            row.setTag(holder);
        } else {
            holder = (MenuViewHolder) row.getTag();
        }

        MenuRow item = getItem(position);
        holder.mIcon.setImageResource(item.getMenuIcon());
        holder.mTitle.setText(item.getMenuText());
        if (item.isSelected()) holder.mIndicator.setVisibility(View.VISIBLE);
        else holder.mIndicator.setVisibility(View.GONE);

        return row;
    }

    public void setHighlighted(String name) {
        for (MenuRow item : mMenuItems) item.setSelected(item.getMenuText().equals(name));
        notifyDataSetChanged();
    }

    static class MenuViewHolder {
        ImageView mIcon;
        TextView mTitle;
        View mIndicator;
    }
}

