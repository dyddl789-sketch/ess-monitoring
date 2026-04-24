package com.lgy.ess_monitoring.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EssMemberDTO {
	private int member_id;
	private String member_name;
	private String member_userid;
	private String member_pw;
	private String phone;
	private String email;
	private String join_date;
}
