package com.example.medic_app.binding;

import androidx.databinding.BindingAdapter;
import androidx.recyclerview.widget.RecyclerView;

import android.graphics.Bitmap;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.example.medic_app.utils.BarcodeImage;
import rx.Observable;
import rx.Subscriber;

/**
 * Created by ccl on 2017/2/8.
 * DataBinding 的BindingAdapter类
 */

public class DataBindingHelper {

    @BindingAdapter("recyclerAdapter")
    public static void setRecyclerAdapter(RecyclerView recyclerView, RecyclerView.Adapter adapter) {
        if (adapter != null) {
            recyclerView.setHasFixedSize(true);
            recyclerView.setAdapter(adapter);
        }
    }

    @BindingAdapter("qrImage")
    public static void setQrImage(final ImageView imageView, final String qrCode) {
        Observable.just(qrCode)
                .map(s -> {
                    if (TextUtils.isEmpty(s)) {
                        return null;
                    }
                    return BarcodeImage.bitmap(imageView.getContext(), s);
                })
                .subscribe(new Subscriber<Bitmap>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onNext(Bitmap bitmap) {
                        imageView.setImageBitmap(bitmap);
                    }
                });
    }

    @BindingAdapter("addTextChangeListener")
    public static void addTextChangeListener(TextView view, TextWatcher watcher) {
        view.addTextChangedListener(watcher);
    }

    @BindingAdapter("onViewClick")
    public static void setOnViewClick(View view, View.OnClickListener listener) {
        view.setOnClickListener(listener);
    }
}
