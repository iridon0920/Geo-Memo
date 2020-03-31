<template>
  <div id="map">
    <GmapMap
      :center="{lat:35.170915, lng:136.881537}"
      :zoom="15"
      :options="{streetViewControl: false}"
      map-type-id="terrain"
      class="google-map"
      @click="openMemoWindow($event)"
    >
      <GmapInfoWindow
        :options="infoOptions"
        :position="infoWindowPos"
        :opened="infoWinOpen"
        @closeclick="infoWinOpen=false"
      >{{infoValue}}</GmapInfoWindow>
      <GmapMarker
        :key="index"
        v-for="(m, index) in markers"
        :position="m.position"
        :clickable="true"
        @click="toggleInfoWindow(m)"
      />
    </GmapMap>
    <el-dialog title="入力地点へメモ入力" :visible.sync="dialogFormVisible" width="20%">
      <el-input v-model="dialogText"></el-input>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="createMemo">メモ作成</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "GoogleMap",
  data() {
    return {
      markers: [],
      infoOptions: {
        pixelOffset: {
          width: 0,
          height: -35
        }
      },
      infoWindowPos: null,
      infoWinOpen: false,
      infoValue: "",
      dialogFormVisible: false,
      dialogText: "",
      lat: 0,
      lng: 0
    };
  },
  methods: {
    toggleInfoWindow(marker) {
      this.infoWindowPos = marker.position;
      this.infoWinOpen = true;
      this.infoValue = marker.text;
    },
    openMemoWindow($event) {
      (this.dialogText = ""), (this.lat = $event.latLng.lat());
      this.lng = $event.latLng.lng();
      this.dialogFormVisible = true;
    },
    async createMemo() {
      this.dialogFormVisible = false;
      await this.axios.post(
        "http://geo-memo-api-lb-24391501.ap-northeast-1.elb.amazonaws.com/api/memo/",
        {
          text: this.dialogText,
          latitude: this.lat,
          longitude: this.lng
        }
      );
      this.loadMarkers();
    },
    loadMarkers() {
      this.axios
        .get(
          "http://geo-memo-api-lb-24391501.ap-northeast-1.elb.amazonaws.com/api/memo/"
        )
        .then(response => {
          for (let res of response.data) {
            this.markers.push({
              position: { lat: res.latitude, lng: res.longitude },
              text: res.text
            });
          }
        });
    }
  },
  mounted: function() {
    this.loadMarkers();
  }
};
</script>

<style scoped>
.google-map {
  width: 70%;
  height: 650px;
  margin: auto;
}
</style>
