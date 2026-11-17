`default_nettype none
module axis_skid_arbiter #(parameter DATA_W=32, KEEP_W=4) (
  input wire clk, input wire rst_n,
  input wire [DATA_W-1:0] s0_axis_tdata, input wire [KEEP_W-1:0] s0_axis_tkeep, input wire s0_axis_tvalid, output wire s0_axis_tready, input wire s0_axis_tlast,
  input wire [DATA_W-1:0] s1_axis_tdata, input wire [KEEP_W-1:0] s1_axis_tkeep, input wire s1_axis_tvalid, output wire s1_axis_tready, input wire s1_axis_tlast,
  output reg [DATA_W-1:0] m_axis_tdata, output reg [KEEP_W-1:0] m_axis_tkeep, output reg m_axis_tvalid, input wire m_axis_tready, output reg m_axis_tlast
);
  reg lock_r, sel_r, rr_r, skid_v; reg [DATA_W-1:0] skid_d; reg [KEEP_W-1:0] skid_k; reg skid_l;
  wire pipe_rdy = !skid_v;
  wire grant = lock_r ? sel_r : ((s0_axis_tvalid && s1_axis_tvalid) ? rr_r : (s1_axis_tvalid ? 1'b1 : 1'b0));
  wire mux_v = grant ? s1_axis_tvalid : s0_axis_tvalid;
  wire [DATA_W-1:0] mux_d = grant ? s1_axis_tdata : s0_axis_tdata;
  wire [KEEP_W-1:0] mux_k = grant ? s1_axis_tkeep : s0_axis_tkeep;
  wire mux_l = grant ? s1_axis_tlast : s0_axis_tlast;
  assign s0_axis_tready = pipe_rdy && (lock_r ? (sel_r==1'b0) : (s0_axis_tvalid && (!s1_axis_tvalid || rr_r==1'b0)));
  assign s1_axis_tready = pipe_rdy && (lock_r ? (sel_r==1'b1) : (s1_axis_tvalid && (!s0_axis_tvalid || rr_r==1'b1)));
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin lock_r<=0; sel_r<=0; rr_r<=0; skid_v<=0; skid_d<=0; skid_k<=0; skid_l<=0; m_axis_tvalid<=0; m_axis_tdata<=0; m_axis_tkeep<=0; m_axis_tlast<=0; end
    else begin
      if (mux_v && pipe_rdy) begin
        if (mux_l) begin lock_r<=0; rr_r<=~grant; end
        else begin lock_r<=1; sel_r<=grant; end
      end
      if (skid_v) begin
        if (m_axis_tvalid && m_axis_tready) begin m_axis_tdata<=skid_d; m_axis_tkeep<=skid_k; m_axis_tlast<=skid_l; m_axis_tvalid<=1; skid_v<=0; end
      end else if (!m_axis_tvalid || m_axis_tready) begin
        m_axis_tvalid <= mux_v;
        if (mux_v) begin m_axis_tdata<=mux_d; m_axis_tkeep<=mux_k; m_axis_tlast<=mux_l; end
      end else if (mux_v) begin skid_v<=1; skid_d<=mux_d; skid_k<=mux_k; skid_l<=mux_l; end
    end
  end
endmodule
`default_nettype wire
