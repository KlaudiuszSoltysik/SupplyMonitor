<template>
  <form @submit.prevent="submitForm">
    <div>
      <label for="email">Email:</label>
      <br>
      <input
          id="email"
          v-model="form.email"
          placeholder="Enter your email"
          required
          type="email"
      />
    </div>
    <div>
      <label for="password">Password:</label>
      <br>
      <input
          id="password"
          v-model="form.password"
          placeholder="Enter your password"
          required
          type="password"
      />
    </div>
    <button type="submit">Submit</button>
  </form>
  <br>
  <p v-if="error" class="error">{{ error }}</p>
  <p v-if="success" class="success">{{ success }}</p>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      form: {
        email: "",
        password: ""
      },
      error: null,
      success: null
    };
  },
  methods: {
    async submitForm() {
      try {
        this.error = null;
        this.success = null;

        const response = await axios.post("http://127.0.0.1:8000/", null,
            {"params": this.form})
            .catch((error) => {
              console.log(error);
            });

        if (response.data) {
          this.$router.push({name: 'Home'});
        }
      } catch (err) {
        this.error = err.response?.data?.message || "An error occurred during submission.";
      }
    }
  }
};
</script>

<style scoped>

</style>
