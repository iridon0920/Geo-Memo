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
      infoValue: ""
    };
  },
  methods: {
    toggleInfoWindow(marker) {
      this.infoWindowPos = marker.position;
      this.infoWinOpen = true;
      this.infoValue = marker.text;
    },
    async openMemoWindow($event) {
      const lat = $event.latLng.lat();
      const lng = $event.latLng.lng();
      await this.axios.post(
        "http://geo-memo-api-lb-24391501.ap-northeast-1.elb.amazonaws.com/api/memo/",
        {
          text: "map_test",
          latitude: lat,
          longitude: lng
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
