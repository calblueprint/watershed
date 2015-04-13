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
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Photos.Photo;
import com.blueprint.watershed.Photos.PhotoPagerAdapter;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

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
    
    protected Button mTakePhotoButton;
    protected MainActivity mParentActivity;
    protected NetworkManager mNetworkManager;

    protected EditText mTitleField;
    protected EditText mAddressField;
    protected EditText mCityField;
    protected EditText mZipField;
    protected EditText mStateField;
    protected EditText mDescriptionField;

    // Cover Photo Pager
    protected CoverPhotoPagerView mImagePager;
    protected PhotoPagerAdapter mImageAdapter;
    protected List<Photo> mPhotoList;

    // Buttons
    protected ImageButton mDeletePhotoButton;
    protected ImageButton mAddPhotoButton;
    protected Button mSubmit;

    protected RelativeLayout mLayout;

    protected Integer mSiteID;
    protected MiniSite mMiniSite;

    // Camera Stuff
    protected static final int CAMERA_REQUEST = 1337;
    protected static final int SELECT_PHOTO_REQUEST = 69;
    protected String mCurrentPhotoPath;

    // Dialog Stuff
    protected static final String DIALOG_TAG = "PickPhotoTypeDialog";
    protected static final int DIALOG_REQUEST_CODE = 200;

    public void setSite(Integer site) { mSiteID = site; }
    public void setMiniSite(MiniSite miniSite) { mMiniSite = miniSite; }

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
        // Inflate the layout for this fragment
        super.onCreateView(inflater, container, savedInstanceState);
        return inflater.inflate(R.layout.fragment_create_mini_site, container, false);
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
    protected void setButtonListeners() {
        mDeletePhotoButton = (ImageButton) mParentActivity.findViewById(R.id.mini_site_delete_photo);
        mAddPhotoButton = (ImageButton) mParentActivity.findViewById(R.id.mini_site_add_photo);

        // Sets up Image Pager
        mImagePager = (CoverPhotoPagerView) mParentActivity.findViewById(R.id.mini_site_photo_pager_view);
        mImageAdapter = new PhotoPagerAdapter(mParentActivity, getPhotos());
        mImagePager.setAdapter(mImageAdapter);

        mLayout = (RelativeLayout) mParentActivity.findViewById(R.id.mini_site_create_layout);
        mTitleField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_title);
        mDescriptionField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_description);
        mAddressField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_address);
        mCityField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_city);
        mZipField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_zip);
        mStateField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_state);

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

        boolean hasErrors = false;

        try {
            int zipCode = Integer.parseInt(mZipField.getText().toString());
            if (zipCode < 0) {
                mZipField.setError("Invalid zip code");
                hasErrors = true;
            }
        }
        catch (Exception e) {
            mZipField.setError("Invalid zip code");
            hasErrors = true;
        }

        EditText[] textFields = { mTitleField, mDescriptionField, mAddressField,
                                  mCityField, mStateField, mZipField };

        for (EditText editText : textFields) {
            if (editText.getText().toString().length() == 0) {
                editText.setError("Cannot be blank!");
                hasErrors = true;
            }
        }

        if (hasErrors) return;

        for (Photo photo : mPhotoList) photo.getImage(mParentActivity);

        miniSite.setName(mTitleField.getText().toString());
        miniSite.setDescription(mDescriptionField.getText().toString());
        miniSite.setStreet(mAddressField.getText().toString());
        miniSite.setCity(mCityField.getText().toString());
        miniSite.setZipCode(Integer.valueOf(mZipField.getText().toString()));
        miniSite.setLatitude(0f); // Get this later
        miniSite.setLongitude(0f); // Get this later
        miniSite.setFieldReportsCount(miniSite.getFieldReportsCount());
        miniSite.setState(mStateField.getText().toString());
        miniSite.setSiteId(mSiteID);
        miniSite.setPhotos(mPhotoList);

        new Thread(new Runnable() {
            @Override
            public void run() {
                submitMiniSite(miniSite);
            }
        }).start();
    }

    private void deleteMiniSite() {
        
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
            photo = (Bitmap) data.getExtras().get("data");

        }
        else if (requestCode == SELECT_PHOTO_REQUEST && resultCode == MainActivity.RESULT_OK){
            Uri targetUri = data.getData();

            try { photo = BitmapFactory.decodeStream(mParentActivity.getContentResolver().openInputStream(targetUri)); }
            catch (FileNotFoundException e) { e.printStackTrace(); }
        }

        if (photo != null) {
            mPhotoList.add(new Photo(photo));
            mImageAdapter.notifyDataSetChanged();
            mImagePager.setCurrentItem(mPhotoList.size() - 1);
        }
    }

    /**
     * Handles taking a photo - starts new activity
     */
    public void onTakePhotoButtonPressed(){
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
}
