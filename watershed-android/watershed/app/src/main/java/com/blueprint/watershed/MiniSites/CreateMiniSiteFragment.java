package com.blueprint.watershed.MiniSites;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.android.volley.Response;
import com.blueprint.watershed.Activities.MainActivity;
import com.blueprint.watershed.Networking.MiniSites.CreateMiniSiteRequest;
import com.blueprint.watershed.Networking.NetworkManager;
import com.blueprint.watershed.R;
import com.blueprint.watershed.Sites.Site;
import com.blueprint.watershed.Sites.SiteListFragment;

import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

/**
 * Use the {@link CreateMiniSiteFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class CreateMiniSiteFragment extends Fragment implements View.OnClickListener{

    private Button mTakePhotoButton;
    private MainActivity mMainActivity;
    private View mView;
    private NetworkManager mNetworkManager;

    private EditText mTitleField;
    private EditText mAddressField;
    private EditText mCityField;
    private EditText mZipField;
    private EditText mStateField;
    private EditText mDescriptionField;

    private Site mSite;

    // Camera Stuff
    private static final int CAMERA_REQUEST = 1337;
    private String mCurrentPhotoPath;

    /**
     * Use this factory method to create a new instance of
     * this fragment using the provided parameters.
     *
     * @return A new instance of fragment CreateMiniSiteFragment.
     */
    public static CreateMiniSiteFragment newInstance(Site site) {
        CreateMiniSiteFragment fragment = new CreateMiniSiteFragment();
        fragment.setSite(site);
        return fragment;
    }

    public void setSite(Site site) { mSite = site; }

    public CreateMiniSiteFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mNetworkManager = NetworkManager.getInstance(getActivity().getApplicationContext());
        mMainActivity = (MainActivity) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        mView = inflater.inflate(R.layout.fragment_create_mini_site, container, false);
        setButtonListeners(mView);
        return mView;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.empty, menu);
        super.onCreateOptionsMenu(menu, inflater);

    }


    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);

    }

    public void onClick(View view) {
        Log.e("Some Mini Site Button", "Pressed");
        switch (view.getId()) {
            case R.id.take_photo_button:
                Log.e("Photo Mini Site Button", "Pressed");
                onTakePhotoButtonPressed(view);
                break;
            case R.id.create_mini_site_submit:
                Log.e("Create Mini Site Button", "Pressed");
                createMiniSite(view);
                break;
        }
    }

    // Image Handling
    private File createImageFile() throws IOException {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(
                imageFileName,
                ".jpg",
                storageDir
        );
        mCurrentPhotoPath = "file:" + image.getAbsolutePath();
        return image;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
//        ImageView fieldReportImageView = (ImageView)mView.findViewById(R.id.mini_site_image);
//        if (requestCode == CAMERA_REQUEST && resultCode == mMainActivity.RESULT_OK) {
//            Bitmap photo = (Bitmap) data.getExtras().get("data");
//            fieldReportImageView.setImageBitmap(photo);
//        }
    }

    // Button Handlers

    public void onTakePhotoButtonPressed(View takePhotoButton){
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(mMainActivity.getPackageManager()) != null) {
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                Log.e("Mini Site Photo", "Error");
            }
            if (photoFile != null) {
                //takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
                //Uri.fromFile(photoFile));
                startActivityForResult(takePictureIntent, CAMERA_REQUEST);
            }
        }
    }

    private void setButtonListeners(View view){
        Button submitButton = (Button)view.findViewById(R.id.create_mini_site_submit);
        mTitleField = (EditText)view.findViewById(R.id.create_mini_site_title);
        mDescriptionField = (EditText)view.findViewById(R.id.create_mini_site_description);
        mAddressField = (EditText)view.findViewById(R.id.create_mini_site_address);
        mCityField = (EditText)view.findViewById(R.id.create_mini_site_city);
        mZipField = (EditText)view.findViewById(R.id.create_mini_site_zip);
        mStateField = (EditText)view.findViewById(R.id.create_mini_site_state);
        submitButton.setOnClickListener(this);
    }

    public void createMiniSiteRequest(MiniSite miniSite){
        HashMap<String, JSONObject> params = new HashMap<String, JSONObject>();

        CreateMiniSiteRequest createMiniSiteRequest = new CreateMiniSiteRequest(getActivity(), miniSite, params, new Response.Listener<MiniSite>() {
            @Override
            public void onResponse(MiniSite miniSite) {
                SiteListFragment siteList = SiteListFragment.newInstance();
                mMainActivity.replaceFragment(siteList);
                Log.e("successful mini site", "creation");
            }
        });

        mNetworkManager.getRequestQueue().add(createMiniSiteRequest);
    }

    public void createMiniSite(View MiniSiteButton){

        MiniSite miniSite = new MiniSite();

        String miniSiteTitle = ((EditText)mView.findViewById(R.id.create_mini_site_title)).getText().toString();
        //ImageView image = (ImageView)mView.findViewById(R.id.mini_site_image);
        //Bitmap miniSitePhoto = ((BitmapDrawable)image.getDrawable()).getBitmap();

        miniSite.setName(miniSiteTitle);
        miniSite.setDescription(mDescriptionField.getText().toString());
        miniSite.setStreet(mAddressField.getText().toString());
        miniSite.setCity(mCityField.getText().toString());
        miniSite.setZipCode(94563);
        miniSite.setLatitude("0");
        miniSite.setLongitude("0");
        miniSite.setFieldReportsCount(0);
        miniSite.setState("CA");
        miniSite.setSiteId(mSite.getId());

        createMiniSiteRequest(miniSite);
    }

    @Override
    public void onDetach() {
        super.onDetach();
    }

}
