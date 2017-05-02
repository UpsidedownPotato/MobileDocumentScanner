package com.untitled.mobiledocumentscanner;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import java.util.ArrayList;

/**
 * Created by J on 24-Apr-17.
 */

public class ViewPagerAdapter extends PagerAdapter{
    private Context context;
    private ArrayList<Page> pages;
    private boolean fullscreen;
    private int docID;
    private String ip;

    public ViewPagerAdapter(Context context, ArrayList<Page> pages, Boolean fullscreen, int docID, String ip) {
        this.context = context;
        this.pages = pages;
        this.fullscreen = fullscreen;
        this.docID = docID;
        this.ip = ip;
    }

    @Override
    public int getCount() {
        return pages.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((ImageView) object);
    }

    @Override
    public Object instantiateItem(final ViewGroup container, int i) {
        final ImageView imageView = new ImageView(context);
        imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        imageView.setImageBitmap(pages.get(i).getImage());
        if (!fullscreen) {
            if (pages.get(i).getImageID() != -1) {
                imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ImageActivity.start(context, pages, docID, ip);
                    }
                });
            } else {
                imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        CameraActivity.start(context, docID, 1, ip);
                    }
                });
            }
        }
        container.addView(imageView, 0);

        return imageView;
    }

    @Override
    public void destroyItem(ViewGroup container, int i, Object obj){
        container.removeView((ImageView) obj);
    }
}
