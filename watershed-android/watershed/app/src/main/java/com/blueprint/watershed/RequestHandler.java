
/*
Singleton Request Handler to interface with Network.
 */
public class RequestHandler {
    /**
     * An object to handle API calls at the HTTP request level.
     */
    private static MySingleton mInstance;
    private RequestQueue mRequestQueue;
    private ImageLoader mImageLoader;
    private static Context mCtx;


    /** Returns a RequestHandler by assigning CONTEXT, an applicaiton
     *  context set by the caller, to a RequestQueue object, which
     *  handles background threading of HTTP requests.
     */
    private RequestHandler(Context context) {
        mCtx = context;
        mRequestQueue = getRequestQueue();

        mImageLoader = new ImageLoader(mRequestQueue,
                new ImageLoader.ImageCache() {
                    private final LruCache<String, Bitmap>
                            cache = new LruCache<String, Bitmap>(20);

                    @Override
                    public Bitmap getBitmap(String url) {
                        return cache.get(url);
                    }

                    @Override
                    public void putBitmap(String url, Bitmap bitmap) {
                        cache.put(url, bitmap);
                    }
                });
    }

    /**
     * Ensures singleton requestHandler that survies the duration of the Application
     * Lifecycle.
     * @param context
     * @return
     */
    public static synchronized RequestHandler getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new RequestHandler(context);
        }
        return mInstance;
    }

    public ImageLoader getImageLoader(){
        return mImageLoader;
    }

    /** Returns a JSONArray object by taking in a URL.
     *  The Volley API only allows GET requests to return
     *  a JSON array, so no Method argument is necessary.
     *  Similarly, the API does not accept parameters for a
     *  JsonArrayRequest object.
     */
    public JSONArray arrayRequest(String url) {
        /**
         * TODO: Consider overwriting volley source to allow other
         * types of http requests.
         */

        final JSONArray response[] = new JSONArray[1];

        JsonArrayRequest request = new JsonArrayRequest(url,
                new Response.Listener<JSONArray>() {
                    @Override
                    public void onResponse(JSONArray jsonArray) {
                        Log.d("Queue", "Response received");
                        response[0] = jsonArray;
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.d("Volley Error", volleyError.getMessage());
            }
        }
        );

        queue.add(request);

        return response[0];
    }


    /** Returns a JSONObject of the response at the given
     *  URL with the given PARAMS and specified METHOD.
     *  PARAMS is a JSONObject containing the POST or PUT data.
     */
    public JSONObject objectRequest(int method, String url, JSONObject params) {

        final JSONObject response[] = new JSONObject[1];

        JsonObjectRequest request = new JsonObjectRequest(method, url, params,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        Log.d("Queue", "Response received");
                        response[0] = jsonObject;
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.d("Volley Error", volleyError.getMessage());
            }
        }
        );

        queue.add(request);

        return response[0];
    }

    /**
     * returns a bitmap response from an image request
     * @param url
     * @param params
     * @return
     */
    public Bitmap imageRequest( String url, JSONObject params ){

        Bitmap returnedImage;

        ImageRequest request = new ImageRequest(url,
                new Response.Listener() {
                    @Override
                    public void onResponse(Bitmap bitmap) {
                        returnedImage = bitmap;
                    }
                }, 0, 0, null,
                new Response.ErrorListener() {
                    public void onErrorResponse(VolleyError error) {
                        Log.e("Volley Error")
                        //mImageView.setImageResource(R.drawable.image_load_error);
                    }
                });
    }



}