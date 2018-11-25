
import React, { Component } from 'react';
const { NativeModules, requireNativeComponent, findNodeHandle } = require('react-native');
const { ImagePickerManager: NativeImagePickerManager } = NativeModules;

class MiniViewComponent extends Component {
}
const MiniView = {
  component: requireNativeComponent('MiniView', MiniViewComponent),
  use: (ref) => {
    NativeModules['MiniViewManager']['use'](findNodeHandle(ref));
  },
};
export { MiniView };

const DEFAULT_OPTIONS = {
  title: 'Select a Photo',
  cancelButtonTitle: 'Cancel',
  takePhotoButtonTitle: 'Take Photo…',
  chooseFromLibraryButtonTitle: 'Choose from Library…',
  quality: 1.0,
  allowsEditing: false,
  permissionDenied: {
    title: 'Permission denied',
    text: 'To be able to take pictures with your camera and choose images from your library.',
    reTryTitle: 're-try',
    okTitle: 'I\'m sure',
  }
};

const ImagePickerManager = {
  ...NativeImagePickerManager,
  showImagePicker: function showImagePicker(options, callback) {
    if (typeof options === 'function') {
      callback = options;
      options = {};
    }
    return NativeImagePickerManager.showImagePicker({...DEFAULT_OPTIONS, ...options}, callback)
  },
  enableSwipableImageLibrary: function(options, callback) {
    if (typeof options === 'function') {
      callback = options;
      options = {};
    }
    if (!callback)
      callback = () => {};
    return NativeImagePickerManager.enableSwipableImageLibrary({...DEFAULT_OPTIONS, ...options}, callback)
  },
  enableSwipableCamera: function(options, callback) {
    if (typeof options === 'function') {
      callback = options;
      options = {};
    }
    if (!callback)
      callback = () => {};
    return NativeImagePickerManager.enableSwipableCamera({...DEFAULT_OPTIONS, ...options}, callback)
  },
  disableSwipable: function() {
    return NativeImagePickerManager.disableSwipable()
  },
}

export default ImagePickerManager;
