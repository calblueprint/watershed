package com.blueprint.watershed.Views;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.Rect;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

import com.blueprint.watershed.R;


/**
 * Created by charlesx on 11/12/14.
 */
public class CircleImageView extends ImageView {

    // Show states
    public static final int SHOW_NORMAL = 0;
    public static final int SHOW_APPROVE = 1;
    public static final int SHOW_REJECT = 2;
    public static final int SHOW_SPY = 3;
    public static final int SHOW_RESISTANCE = 4;

    // Constants
    protected static final int WHITE_STROKE_COLOR = Color.WHITE;
    protected static final int LTGRAY_STROKE_COLOR = Color.LTGRAY;
    protected static final int UNFOCUSED_ALPHA = 102;
    protected static final int UNSELECTABLE_ALPHA = 51;
    protected static float STROKE_WIDTH;

    // Conditions
    private static boolean isDraggable;
    private boolean isStateChanged = false;
    private boolean isSelectEnabled = false;
    private boolean isSelected = false;
    private boolean isFlipped = false;
    private boolean isSuperFaded = false;
    private boolean isFaded = false;

    // Fields
    private String mText;
    private Bitmap mBitmap;

    public CircleImageView(Context context) {
        super(context);
        initializeSelf();
    }

    public CircleImageView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        initializeSelf();
    }

    public CircleImageView(Context context, AttributeSet attributeSet, int defStyle) {
        super(context, attributeSet, defStyle);
        initializeSelf();
    }

    private void initializeSelf() {
        if (STROKE_WIDTH == 0) {
            // getWidth() is always 0 here. Only in onDraw is it non-zero.
            //STROKE_WIDTH = 2.5f * getWidth() / getResources().getDimension(R.dimen.player_image_inner_view_dimen);
            STROKE_WIDTH = getResources().getDimension(R.dimen.player_image_border_width);
        }
    }

    @Override
    protected void onDraw(Canvas canvas) {
        Bitmap bitmapToDraw;
        if (mBitmap == null || this.isStateChanged()) {
            setBitmap();
            this.isStateChanged = false;
            bitmapToDraw = mBitmap;
        } else {
            bitmapToDraw = mBitmap;
        }
        canvas.drawBitmap(bitmapToDraw, 0,0, null);
    }

    /**
     * getCroppedBitmap scales the bitmap's width and height, centers the bitmap, then
     * draws it on a canvas with width = height = diameter.
     *
     * @param bitmap the src of the ImageView
     * @param diameter the width/height of ImageView (which is a square)
     * @return a bitmap
     */
    public static Bitmap getCroppedBitmap(Bitmap bitmap, int diameter) {
        if (bitmap == null) {
            return null;
        }

        //Bitmap scaledMap; // TODO: wonky
        int w = bitmap.getWidth(); int h = bitmap.getHeight();
        Log.d("DEBUG", "Diameter: " + Integer.toString(diameter));
        Log.d("DEBUG", "Width: " + Integer.toString(w) + ", Height: " + Integer.toString(h));

        if (h == diameter && w == diameter) {
            //scaledMap = bitmap;
        } else if (h > w) {
            int scaledHeight = (int)(diameter/(float)(w) * h);
            Log.d("DEBUG", "scaledHeight: " + Integer.toString(scaledHeight));
            int offsetY = (scaledHeight - diameter)/2;
            bitmap = Bitmap.createScaledBitmap(bitmap, diameter, scaledHeight, false);
            bitmap = Bitmap.createBitmap(bitmap, 0, offsetY, diameter, diameter);
            //scaledMap = Bitmap.createScaledBitmap(bitmap, diameter, scaledHeight, false);
            //scaledMap = Bitmap.createBitmap(scaledMap, 0, offsetY, diameter, diameter);
        } else if (w > h) {
            int scaledWidth = (int)(diameter/(float)(h) * w);
            Log.d("DEBUG", "scaledWidth: " + Integer.toString(scaledWidth));
            int offsetX = (scaledWidth - diameter)/2;
            bitmap = Bitmap.createScaledBitmap(bitmap, scaledWidth, diameter, false);
            bitmap = Bitmap.createBitmap(bitmap, offsetX, 0, diameter, diameter);
            //scaledMap = Bitmap.createScaledBitmap(bitmap, scaledWidth, diameter, false);
            //scaledMap = Bitmap.createBitmap(scaledMap, offsetX, 0, diameter, diameter);
        } else {
            bitmap = Bitmap.createScaledBitmap(bitmap, diameter, diameter, false);
            //scaledMap = Bitmap.createScaledBitmap(bitmap, diameter, diameter, false);
        }

        Log.d("DEBUG", "scaledMap width: " + Integer.toString(bitmap.getWidth()) +
                ", scaledMap height: " + Integer.toString(bitmap.getHeight()));
        //Log.d("DEBUG", "scaledMap width: " + Integer.toString(scaledMap.getWidth()) +
        //        ", scaledMap height: " + Integer.toString(scaledMap.getHeight()));

        // Finish scaling and cropping
        // Start making circular view
        Bitmap output = Bitmap.createBitmap(diameter, diameter, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);

        final Paint paint = new Paint();
        final Rect rect = new Rect(0, 0, diameter, diameter);

        paint.setAntiAlias(true);
        paint.setFilterBitmap(true);
        paint.setDither(true);

        canvas.drawARGB(0, 0, 0, 0);
        paint.setColor(Color.WHITE);
        canvas.drawCircle(diameter / 2, diameter / 2, diameter / 2 - 2, paint);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(bitmap, rect, rect, paint);
        //canvas.drawBitmap(scaledMap, rect, rect, paint);

        Log.d("DEBUG", "output width: " + Integer.toString(output.getWidth()) +
                ", output height: " + Integer.toString(output.getHeight()));
        return output;
    }

    /**
     * getBorderedBitmap adds a circular border to a bitmap
     *
     * @param bitmap the bitmap to add a border to
     * @param diameter the width/height of ImageView (which is a square)
     * @param strokeWidth the width of the border
     * @param strokeColor the color of the border
     * @return a bitmap
     */
    public static Bitmap getBorderedBitmap(Bitmap bitmap, int diameter, float strokeWidth, int strokeColor) {
        Bitmap output;
        if (bitmap != null) {
            //output = Bitmap.createBitmap(bitmap, 0, 0, diameter, diameter); IMMUTABLE! Does not work.
            // --EQUIVALENT-TO--
            output = bitmap.copy(Bitmap.Config.ARGB_8888, true);
        } else {
            output = Bitmap.createBitmap(diameter, diameter, Bitmap.Config.ARGB_8888);
        }
        Canvas canvas = new Canvas(output);
        if (bitmap == null) { canvas.drawARGB(0, 0, 0, 0); }

        final Paint circlePaint = new Paint();
        circlePaint.setAntiAlias(true);
        circlePaint.setDither(true);
        circlePaint.setStyle(Paint.Style.STROKE);
        circlePaint.setStrokeWidth(strokeWidth);
        circlePaint.setColor(strokeColor);
        canvas.drawCircle(diameter / 2, diameter / 2, diameter / 2 - strokeWidth, circlePaint);
        return output;
    }

    /**
     * getTextBitmap makes a bitmap with text in it.
     *
     * @param text the text to draw on the bitmap
     * @param diameter the width/height of ImageView (which is a square)
     * @param textColor the color of the text
     * @return a bitmap
     */
    protected static Bitmap getTextBitmap(String text, int diameter, int textColor) {
        if (text == null) {
            return null;
        }
        Bitmap output = Bitmap.createBitmap(diameter, diameter, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);

        final Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setDither(true);
        paint.setTextAlign(Paint.Align.CENTER);
        paint.setColor(textColor);
        //paint.setTypeface(ethnocentric_font);
        float textSize = diameter / text.length() * 8/5; // Dunno how to dynamically resize it well
        paint.setTextSize(textSize);
        float xPos = canvas.getWidth() / 2;
        float yPos = ((canvas.getHeight() / 2) - ((paint.descent() + paint.ascent()) / 2));
        canvas.drawText(text, xPos, yPos, paint);
        return output;
    }

    /**
     * getFadedBitmap draws the bitmap with a given alpha.
     *
     * DEPRECATED! Just use this.setAlpha(..).
     *
     * @param bitmap the bitmap to fade.
     * @param alpha the transparency level.
     * @return a bitmap.
     */
    protected static Bitmap getFadedBitmap(Bitmap bitmap, int alpha) {
        if (bitmap == null) {
            return null;
        }
        Bitmap output = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getWidth(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(output);
        Paint paint = new Paint();
        paint.setAntiAlias(true);
        paint.setFilterBitmap(true);
        paint.setDither(true);
        paint.setColor(Color.WHITE);
        paint.setAlpha(alpha);
        canvas.drawBitmap(bitmap, 0, 0, paint);
        return output;
    }

    /**
     * setBitmap takes the drawable and draws it. If drawable is null, draws the text.
     * If text is null, draws an empty circle.
     */
    private void setBitmap() {
        Drawable drawable = getDrawable();
        int w = getWidth(), h = getHeight();
        Bitmap bitmap;

        if (w == 0 || h == 0) {
            return;
        }

        int biggest = w > h ? w : h;
        if (drawable == null) {
            // getTextBitmap returns null if mText is null; getBorderedBitmap can handle null bitmaps.
            bitmap = getTextBitmap(mText, biggest, Color.WHITE);
            bitmap = getBorderedBitmap(bitmap, biggest, STROKE_WIDTH, LTGRAY_STROKE_COLOR);
        } else {
            bitmap = ((BitmapDrawable) drawable).getBitmap();
        }

        bitmap = getCroppedBitmap(bitmap, biggest);
//        bitmap = getBorderedBitmap(bitmap, biggest, STROKE_WIDTH, WHITE_STROKE_COLOR);
        if (this.isSuperFaded()) {
            this.setAlpha(UNSELECTABLE_ALPHA / 255f);
        } else if ((this.isSelectEnabled() && !this.isSelected()) || this.isFaded()) {
            this.setAlpha(UNFOCUSED_ALPHA / 255f);
        } else {
            this.setAlpha(1f);
        }

        mBitmap = bitmap;
        //mBitmap = bitmap.copy(Bitmap.Config.ARGB_8888, true);
    }

    /**
     * Setter and getter for isDraggable.
     */
    public static void setDraggable(boolean bool) { isDraggable = bool; }

    public static boolean isDraggable() { return isDraggable; }

    /**
     * Setter and getter for isSelectEnabled.
     */
    public void setSelectEnabled(boolean bool) {
        isSelectEnabled = bool;
        setSoundEffectsEnabled(bool);
    }

    public boolean isSelectEnabled() { return isSelectEnabled; }

    /**
     * Setter and getter for isSelected.
     */
    public void setSelected(boolean bool) {
        isSelected = bool;
        isStateChanged = true;
    }

    public boolean isSelected() { return isSelected; }

    /**
     * Setter and getter for isFaded.
     */
    public void setFaded(boolean bool) {
        this.isFaded = bool;
        this.isStateChanged = true;
    }

    public boolean isFaded() { return this.isFaded; }

    /**
     * Setter and getter for isSuperFaded.
     */
    public void setSuperFaded(boolean bool) {
        this.isSuperFaded = bool;
        this.isStateChanged = true;
    }

    public boolean isSuperFaded() { return this.isSuperFaded; }

    /**
     * Setter and getter for mText.
     */
    public void setText(String text) {
        mText = text;
        isStateChanged = true;
    }

    public String getText() { return mText; }

    /**
     * Getter for isStateChanged.
     */
    public boolean isStateChanged() { return isStateChanged; }

    /**
     * Override setImageDrawable to toggle isStateChanged.
     * @param drawable
     */
    @Override
    public void setImageDrawable(Drawable drawable) {
        super.setImageDrawable(drawable);
        isStateChanged = true;
    }

    public Drawable getImageDrawable() {
        return getDrawable();
    }

    /**
     * Override setImageResource to toggle isStateChanged.
     *
     * DO NOT USE THIS METHOD!
     *
     * Deprecated because:
     * http://developer.android.com/reference/android/widget/ImageView.html#setImageResource%28int%29
     * "This does Bitmap reading and decoding on the UI thread, which can cause a latency hiccup.
     * If that's a concern, consider using setImageDrawable(android.graphics.drawable.Drawable) or
     * setImageBitmap(android.graphics.Bitmap) and BitmapFactory instead."
     * @param resId
     */
    @Override
    public void setImageResource(int resId) {
        super.setImageResource(resId);
        isStateChanged = true;
    }

}
