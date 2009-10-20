/*
 * Valadoc.Api.- a documentation tool for vala.
 * Copyright (C) 2008 Florian Brosch
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

using Gee;
using Valadoc.Content;


public class Valadoc.Api.ErrorDomain : TypeSymbol {
	public ErrorDomain (Vala.ErrorDomain symbol, Node parent) {
		base (symbol, parent);
	}

	public string? get_cname () {
		return ((Vala.ErrorDomain) symbol).get_cname();
	}

	public override NodeType node_type { get { return NodeType.ERROR_DOMAIN; } }

	public override void accept (Visitor visitor) {
		visitor.visit_error_domain (this);
	}

	protected override Inline build_signature () {
		return new SignatureBuilder ()
			.append_keyword (get_accessibility_modifier ())
			.append_keyword ("errordomain")
			.append_symbol (this)
			.get ();
	}
}
