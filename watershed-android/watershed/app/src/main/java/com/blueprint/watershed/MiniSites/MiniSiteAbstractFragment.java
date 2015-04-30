package com.blueprint.watershed.MiniSites;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AutoCompleteTextView;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.GoogleApis.Places.PlacePredictionAdapter;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Photos.Photo;
import com.blueprint.watershed.Photos.PhotoPagerAdapter;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Utilities.Utility;
import com.blueprint.watershed.Views.CoverPhotoPagerView;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.AutocompletePredictionBuffer;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by charlesx on 3/17/15.
 * Create MiniSiteFragment
 */
public abstract class MiniSiteAbstractFragment extends Fragment implements View.OnClickListener {
    
    protected MainActivity mParentActivity;
    protected NetworkManager mNetworkManager;

    protected EditText mTitleField;
    protected EditText mDescriptionField;
    protected AutoCompleteTextView mAddressField;

    // Cover Photo Pager
    protected CoverPhotoPagerView mImagePager;
    protected PhotoPagerAdapter mImageAdapter;
    protected List<Photo> mPhotoList;

    // Buttons
    protected ImageButton mDeletePhotoButton;
    protected ImageButton mAddPhotoButton;

    protected RelativeLayout mLayout;
    protected Site mSite;
    protected MiniSite mMiniSite;

    // Places API
    protected List<AutocompletePrediction> mPredictions;
    protected PlacePredictionAdapter mPlacesAdapter;

    // Camera Stuff
    protected static final int CAMERA_REQUEST = 1337;
    protected static final int SELECT_PHOTO_REQUEST = 69;
    protected String mCurrentPhotoPath;

    // Dialog Stuff
    protected static final String DIALOG_TAG = "PickPhotoTypeDialog";
    protected static final int DIALOG_REQUEST_CODE = 200;

    public void setSite(Site site) { mSite = site; }
    public void setMiniSite(MiniSite miniSite) { mMiniSite = miniSite; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mParentActivity = (MainActivity) getActivity();
        mNetworkManager = NetworkManager.getInstance(mParentActivity);
        mPredictions = new ArrayList<AutocompletePrediction>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_mini_site, container, false);
        setViews(view);
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.save_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    /**
     * Sets all the views in the fragment
     */
    protected void setViews(View view) {
        mDeletePhotoButton = (ImageButton) view.findViewById(R.id.mini_site_delete_photo);
        mAddPhotoButton = (ImageButton) view.findViewById(R.id.mini_site_add_photo);

        // Sets up Image Pager
        mImagePager = (CoverPhotoPagerView) view.findViewById(R.id.mini_site_photo_pager_view);
        mImageAdapter = new PhotoPagerAdapter(mParentActivity, getPhotos());
        mImagePager.setAdapter(mImageAdapter);

        mPlacesAdapter = new PlacePredictionAdapter(mParentActivity, mPredictions);

        mLayout = (RelativeLayout) view.findViewById(R.id.mini_site_create_layout);
        mTitleField = (EditText) view.findViewById(R.id.create_mini_site_title);
        mDescriptionField = (EditText) view.findViewById(R.id.create_mini_site_description);
        mAddressField = (AutoCompleteTextView) view.findViewById(R.id.create_mini_site_address);
        mAddressField.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (s.toString().length() > 2) getPredictions(s.toString());
            }
        });

        mAddressField.setAdapter(mPlacesAdapter);

        mDeletePhotoButton.setOnClickListener(this);
        mAddPhotoButton.setOnClickListener(this);
    }

    public List<Photo> getPhotos() {
        if (mPhotoList == null) mPhotoList = new ArrayList<>();
        return mPhotoList;
    }

    public void setPhotos(List<Photo> photos) {
        if (mPhotoList == null) mPhotoList = new ArrayList<>();
        mPhotoList = photos;
    }

    /**
     * onClickListeners for the buttons on the page.
     * @param view View that was clicked
     */
    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.mini_site_delete_photo:
                deletePhoto();
                break;
            case R.id.mini_site_add_photo:
                openAddPhotoDialog();
                break;
        }
    }

    private void getPredictions(String string) {
        PendingResult result =
                Places.GeoDataApi.getAutocompletePredictions(mParentActivity.getGoogleApiClient(), string,
                        new LatLngBounds(new LatLng(10, -175), new LatLng(70, -50)), null);
        result.setResultCallback(new ResultCallback<AutocompletePredictionBuffer>() {
            @Override
            public void onResult(AutocompletePredictionBuffer buffer) {
                List<AutocompletePrediction> places = new ArrayList<AutocompletePrediction>();
                for (AutocompletePrediction prediction : buffer) {
                    AutocompletePrediction frozenPrediction = prediction.freeze();
                    places.add(frozenPrediction);
                }
                buffer.release();
                setPlaces(places);
            }
        });
    }

    /**
     * Deletes a photo from the PagerView
     */
    public void deletePhoto() { mImageAdapter.deletePhoto(mImagePager.getCurrentItem()); }

    /**
     * Opens dialog to pick between taking or selecting a photo
     */
    public void openAddPhotoDialog() {
        PickPhotoTypeDialog dialog = PickPhotoTypeDialog.newInstance();
        dialog.setTargetFragment(this, DIALOG_REQUEST_CODE);
        dialog.show(mParentActivity.getSupportFragmentManager(), DIALOG_TAG);
    }

    /**
     * Validates and makes a submit request
     */
    public void validateAndSubmitMiniSite() {
        final MiniSite miniSite = mMiniSite == null ? new MiniSite() : mMiniSite;

        List<String> errorStrings = new ArrayList<String>();

        if (mTitleField.getText().toString().length() == 0) errorStrings.add("Title");
        if (mDescriptionField.getText().toString().length() == 0) errorStrings.add("Description");
        if (mAddressField.getText().toString().length() == 0) errorStrings.add("Address");
        if (mPhotoList.size() < 1) errorStrings.add("Photos");

        if (errorStrings.size() > 0) Utility.setEmpty(mParentActivity, errorStrings);
        else submitMiniSiteRequest(miniSite);
    }

    private void submitMiniSiteRequest(MiniSite miniSite) {
        for (Photo photo : mPhotoList) photo.getImage(mParentActivity);
        miniSite.setName(mTitleField.getText().toString());
        miniSite.setDescription(mDescriptionField.getText().toString());
        miniSite.setStreet(mAddressField.getText().toString());
        miniSite.setLatitude(0f); // Get this later
        miniSite.setLongitude(0f); // Get this later
        miniSite.setFieldReportsCount(miniSite.getFieldReportsCount());
        miniSite.setSiteId(mSite.getId());
        miniSite.setPhotos(mPhotoList);

        new Thread(new Runnable() {
            @Override
            public void run() {
                submitMiniSite(miniSite);
            }
        }).start();
    }

    /**
     * Creates an Image File
     * @return A file
     * @throws IOException
     */
    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(imageFileName, ".jpg", storageDir);
        mCurrentPhotoPath = "file:" + image.getAbsolutePath();
        return image;
    }

    /**
     * Handing our activity results
     * @param requestCode Number telling us which intent was called
     * @param resultCode Number telling us if the request was ok
     * @param data Data passed back by the activity
     */
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Bitmap photo = null;
        if (requestCode == CAMERA_REQUEST && resultCode == MainActivity.RESULT_OK) {
            // Get the dimensions of the View
            int targetW = mImagePager.getWidth();
            int targetH = mImagePager.getHeight();

            // Get the dimensions of the bitmap
            BitmapFactory.Options bmOptions = new BitmapFactory.Options();
            bmOptions.inJustDecodeBounds = true;
            BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);
            int photoW = bmOptions.outWidth;
            int photoH = bmOptions.outHeight;

            // Determine how much to scale down the image
            int scaleFactor = 0;
            if (targetW > 0 && targetH > 0) scaleFactor = Math.min(photoW/targetW, photoH/targetH);

            // Decode the image file into a Bitmap sized to fill the View
            bmOptions.inJustDecodeBounds = false;
            bmOptions.inSampleSize = scaleFactor;
            bmOptions.inPurgeable = true;

            photo = BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);

        }

        else if (requestCode == SELECT_PHOTO_REQUEST && resultCode == MainActivity.RESULT_OK){
            Uri targetUri = data.getData();

            try { photo = BitmapFactory.decodeStream(mParentActivity.getContentResolver().openInputStream(targetUri)); }
            catch (FileNotFoundException e) { e.printStackTrace(); }
        }

        Bitmap scaledBitmap = null;

        if (photo != null) {
            int width = photo.getWidth() / 6;
            int height = photo.getHeight() / 6;
            scaledBitmap = Bitmap.createScaledBitmap(photo, width, height, false);
        }

        if (scaledBitmap != null) {
            mPhotoList.add(new Photo(scaledBitmap));
            mImageAdapter.notifyDataSetChanged();
            mImagePager.setCurrentItem(mPhotoList.size() - 1);
        }
    }

    /**
     * Handles taking a photo - starts new activity
     */
    public void onTakePhotoButtonPressed() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(mParentActivity.getPackageManager()) != null) {
            File photoFile = null;

            try { photoFile = createImageFile(); }
            catch (IOException ex) { Log.e("Mini Site Photo", "Error"); }

            if (photoFile != null) {
                startActivityForResult(takePictureIntent, CAMERA_REQUEST);
            }
        }
    }

    /**
     * Handles selecting a photo - starts new activity
     */
    public void onSelectPhotoButtonPressed() {
        Intent intent = new Intent(Intent.ACTION_PICK,
                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, SELECT_PHOTO_REQUEST);
    }

    /**
     * A method the children of this class must implement
     * @param site Site to submit
     */
    public abstract void submitMiniSite(MiniSite site);

    /**
     * Dialog that allows users to choose between taking and selecting a photo.
     */
    public static class PickPhotoTypeDialog extends DialogFragment {

        public static PickPhotoTypeDialog newInstance() { return new PickPhotoTypeDialog(); }

        @Override
        @NonNull
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            String[] photoArray = { "Select Photo", "Take Photo" };
            AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setTitle("Select a Photo Option!")
                   .setItems(photoArray, new DialogInterface.OnClickListener() {
                       @Override
                       public void onClick(DialogInterface dialog, int which) {
                           if (!(getTargetFragment() instanceof MiniSiteAbstractFragment)) {
                               Log.e("Fragment Error", "Can't even fragment");
                               return;
                           }
                           MiniSiteAbstractFragment fragment = (MiniSiteAbstractFragment) getTargetFragment();

                           if (which == 0) fragment.onSelectPhotoButtonPressed();
                           else fragment.onTakePhotoButtonPressed();
                       }
                   })
                   .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                       @Override
                       public void onClick(DialogInterface dialog, int which) {
                           dialog.dismiss();
                       }
                   });

            return builder.create();
        }
    }

    protected void setPlaces(List<AutocompletePrediction> places) {
        mPredictions.clear();
        mPredictions.addAll(places);
        mPlacesAdapter.notifyDataSetChanged();
    }
}
