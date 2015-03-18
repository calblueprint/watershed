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
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.Photos.Photo;
import com.blueprint.watershed.Photos.PhotoPagerAdapter;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Utilities.Utility;
import com.blueprint.watershed.Views.CoverPhotoPagerView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.SimpleDateFormat;
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

    protected RelativeLayout mLayout;

    protected Site mSite;
    protected MiniSite mMiniSite;

    // Camera Stuff
    protected static final int CAMERA_REQUEST = 1337;
    protected static final int SELECT_PHOTO_REQUEST = 69;
    protected String mCurrentPhotoPath;

    public void setSite(Site site) { mSite = site; }
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
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.take_mini_site_photo_button:
                onTakePhotoButtonPressed();
                break;
            case R.id.create_mini_site_submit:
                validateAndSubmitMiniSite();
                break;
            case R.id.select_mini_site_photo_button:
                onSelectPhotoButtonPressed();
                break;
        }
    }

    // Image Handling
    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(imageFileName, ".jpg", storageDir);
        mCurrentPhotoPath = "file:" + image.getAbsolutePath();
        return image;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        Bitmap photo = null;
        if (requestCode == CAMERA_REQUEST && resultCode == MainActivity.RESULT_OK) {
             photo = (Bitmap) data.getExtras().get("data");

        }
        else if (requestCode == SELECT_PHOTO_REQUEST && resultCode == MainActivity.RESULT_OK){
            Uri targetUri = data.getData();
            try {
                photo = BitmapFactory.decodeStream(mParentActivity.getContentResolver().openInputStream(targetUri));
            }
            catch (FileNotFoundException e){
                e.printStackTrace();
            }
        }

        if (photo != null) {
            mPhotoList.add(new Photo(photo));
            mImageAdapter.notifyDataSetChanged();
        }
    }

    // Button Handlers
    public void onTakePhotoButtonPressed(){
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(mParentActivity.getPackageManager()) != null) {
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                Log.e("Mini Site Photo", "Error");
            }
            if (photoFile != null) {
                startActivityForResult(takePictureIntent, CAMERA_REQUEST);
            }
        }
    }

    public void onSelectPhotoButtonPressed() {
        Intent intent = new Intent(Intent.ACTION_PICK,
                android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, SELECT_PHOTO_REQUEST);
    }

    protected void setButtonListeners() {
        Button submitButton = (Button) mParentActivity.findViewById(R.id.create_mini_site_submit);
        Button takePhoto = (Button) mParentActivity.findViewById(R.id.take_mini_site_photo_button);
        Button selectPhoto = (Button) mParentActivity.findViewById(R.id.select_mini_site_photo_button);

        // Sets up Image Pager
        mImagePager = (CoverPhotoPagerView) mParentActivity.findViewById(R.id.mini_site_photo_pager_view);
        mImageAdapter = new PhotoPagerAdapter(mParentActivity, mPhotoList);
        mImagePager.setAdapter(mImageAdapter);

        mTitleField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_title);
        mDescriptionField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_description);
        mAddressField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_address);
        mCityField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_city);
        mZipField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_zip);
        mStateField = (EditText) mParentActivity.findViewById(R.id.create_mini_site_state);

        takePhoto.setOnClickListener(this);
        selectPhoto.setOnClickListener(this);
        submitButton.setOnClickListener(this);
    }

    public void validateAndSubmitMiniSite() {
        MiniSite miniSite = mMiniSite == null ? new MiniSite() : mMiniSite;

        int zipCode;

        try {
            zipCode = Integer.valueOf(mZipField.getText().toString());
        }
        catch (Exception e){
            Toast toast = Toast.makeText(mParentActivity.getApplicationContext(), "Please use a valid Zip Code", Toast.LENGTH_SHORT);
            toast.show();
            return;
        }
//        Bitmap miniSitePhoto = ((BitmapDrawable)image.getDrawable()).getBitmap();

        miniSite.setName(mTitleField.getText().toString());
        miniSite.setDescription(mDescriptionField.getText().toString());
        miniSite.setStreet(mAddressField.getText().toString());
        miniSite.setCity(mCityField.getText().toString());
        miniSite.setZipCode(Integer.valueOf(mZipField.getText().toString()));
        miniSite.setLatitude(0f); // ?
        miniSite.setLongitude(0f); // ?
        miniSite.setFieldReportsCount(mMiniSite.getFieldReportsCount());
        miniSite.setState(mStateField.getText().toString());
        miniSite.setSiteId(mSite.getId());
        miniSite.setPhotos(mPhotoList);

        Utility.hideKeyboard(mParentActivity, mLayout);
        submitMiniSite(miniSite);
    }

    public abstract void submitMiniSite(MiniSite site);

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
