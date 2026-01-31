package `in`.photomall.photomall_flutter.utils.bubbleShowCase

interface OnBubbleMessageViewListener {
    /**
     * It is called when a user clicks the close action image in the BubbleMessageView
     */
    fun onCloseActionImageClick()


    /**
     * It is called when a user clicks the BubbleMessageView
     */
    fun onBubbleClick()
}