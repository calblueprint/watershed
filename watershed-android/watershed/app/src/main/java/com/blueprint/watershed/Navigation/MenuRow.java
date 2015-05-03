package com.blueprint.watershed.Navigation;

/**
 * Created by charlesx on 4/28/15.
 */
public class MenuRow {

    private boolean isSelected;
    private int menuIcon;
    private String menuText;

    public MenuRow(int icon, String text, boolean selected) {
        isSelected = selected;
        menuIcon = icon;
        menuText = text;
    }

    public boolean isSelected() {
        return isSelected;
    }
    public void setSelected(boolean isSelected) {
        this.isSelected = isSelected;
    }
    public int getMenuIcon() {
        return menuIcon;
    }
    public void setMenuIcon(int menuIcon) {
        this.menuIcon = menuIcon;
    }
    public String getMenuText() {
        return menuText;
    }
    public void setMenuText(String menuText) {
        this.menuText = menuText;
    }
}
