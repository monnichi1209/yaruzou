import { createApp } from 'vue';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#vue-intro',
    data: {
      dynamicMessage: 'これはVue.jsからのメッセージです！'
    },
    methods: {
      changeMessage() {
        this.dynamicMessage = 'メッセージが変更されました！';
      }
    }
  })
});
